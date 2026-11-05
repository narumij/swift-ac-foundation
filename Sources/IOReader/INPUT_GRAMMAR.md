# IOReader の入力文法（現実装の整理案）

現在のソースを基に、APIが扱う入力単位を整理する。AtCoder・ICPCの公式文法ではない。
これは品質保証範囲を決めるための草案であり、以下の全組合せを検証済みと宣言するものではない。
現実装が偶然受理する不正表記は、対応する入力文法には含めない。

## 記法と共通範囲

EBNFの `,` は連接、`|` は選択、`{ ... }` は0回以上、`[ ... ]` は省略可能を表す。
`? ... ?` は説明による文字集合・条件。EOFはバイトではなくストリーム終端。
引数に依存する反復回数や型の値域は、通常のEBNFの外にある制約として記載する。

共通の対象はASCII入力。通常の改行はLF。NULは入力文字として扱わない。
Unicode対応や、異なるAPIを混ぜたときのCRLF対応は、この共通範囲に含めない。

```ebnf
SP = ? ASCII 0x20 ? ;
HT = ? ASCII 0x09 ? ;
LF = ? ASCII 0x0A ? ;
CR = ? ASCII 0x0D ? ;
VT = ? ASCII 0x0B ? ;
FF = ? ASCII 0x0C ? ;
EOF = ? end of input, not a character ? ;

digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
digits = digit, { digit } ;
unsigned-integer = digits ;
signed-integer = [ "-" ], digits ;
decimal = [ "+" | "-" ],
          (digits, [ ".", [ digits ] ] | ".", digits),
          [ ("e" | "E"), [ "+" | "-" ], digits ] ;

reader-space = SP | HT | LF | CR ;
horizontal-space = SP | HT ;
printable = ? ASCII 0x21 through 0x7E ? ;
token = printable, { printable } ;
```

`token` に引用符やバックスラッシュが含まれても、引用・エスケープ構文にはならない。
例えば `"a b"` は一つのトークンではなく、`"a` と `b"` の二つ。
ここでのtokenは共通利用に向けた印字可能ASCIIの範囲。低水準実装にはこれ以外の制御文字を
受理する経路もあるが、意図した文字集合としては採用していない。

整数の `+` は対応表記に含めない。符号なし整数の `-` も含めない。
整数は対象型に収まることが前提。桁・符号・オーバーフローの網羅的な検査は行っていない。
浮動小数点は `atof` に委譲している。上記decimalは通常の十進入力の整理であり、
ロケール、丸め、オーバーフロー、NaN/Infinity、十六進表記の保証は別途検討が必要。

## 単一要素の読み取り

次の `element` を、対象に応じてsigned-integer、unsigned-integer、decimal、tokenに置き換える。

```ebnf
element = signed-integer | unsigned-integer | decimal | token ;
element-read = { reader-space }, element ;
```

先頭の空白を読み飛ばし、値の後ろの区切りは**消費せず残す**。
後続条件としてreader-spaceまたはEOFを要求するが、その境界は上記の消費範囲に含めない。
実装では読取りを止めた区切りを `ungetc` で戻す。EOFを表す内部のNULLは戻さない。
次の単一要素読取りが、残した区切りを含めて先頭の空白を読み飛ばす。
値に到達する前のEOFはエラー。
実装は型に応じた読み取りを行い、上記の選択肢を自動判別するわけではない。
数値の字句解析は従来のままであり、例えば整数の `12x` を12として読みxを残すような
C++数値抽出への完全な互換変更ではない。

| API | 文法上の対象 | 結果 |
| --- | --- | --- |
| `Int.read()` などの符号付き整数 | signed-integer | 対象整数型 |
| `UInt.read()` などの符号なし整数 | unsigned-integer | 対象整数型 |
| `Double.read()` | decimal（上記留保あり） | Double |
| `String.read()` / `.read(read: .word)` | token | String |
| `[Character].read()` / `.read(read: .word)` | token | ASCII文字の配列 |
| `[UInt8].read()` / `.read(read: .word)` | token | バイト配列 |
| 自由関数 `read()` のタプル | 各要素型の読み取りの連接 | タプル |

`Character.read()` と `UInt8.read()` は整数・可変長token読みではなく、後述の固定幅1文字読み。
変換用プロトコルは基礎となる読み取り結果を `convert` に渡す。独自型の値域や変換失敗は
その実装の契約になる。

## 後続を消費しない一文字読み（別名の入口）

```ebnf
cin-space = SP | HT | LF | VT | FF | CR ;
cin-character-read = { cin-space }, printable ;
```

`Character.cin` / `UInt8.cin` と、例外版の `Character.readCin()` / `UInt8.readCin()` が対応する。
ASCII入力で、C++のclassic（C）ロケールの既定の `cin >> char` / `cin >> unsigned char`
と同じ消費規則にする。先頭の空白を飛ばして一文字だけ読み、**後続は区切りも含めて残す**。
文字を読む前のEOFは `unexpectedEOF`。`cin` は `try! readCin()` の入口。
ロケール・書式フラグ・ストリーム状態の互換や、Unicodeの文字単位の読取りは対象外。

例えば `ab\n` への `Character.cin` の2回呼出しは `a`、`b` を返し、LFを残す。
続いて `.line` で読むと、そのLFを消費して空文字列を返す。
既存の `stdin` / `read()` と固定幅 `columns:` も後続を残す。
先頭空白の範囲は従来のreader-spaceを維持しており、cin-spaceとはVT・FFの扱いが異なる。

## 数値・変換要素の一行と固定個数

```ebnf
element-line = element, { horizontal-space, { horizontal-space }, element }, (LF | EOF) ;
```

これは `ElementLineReadable._readLine()` を安定して使用するための正規化した行形式。
**空行・行末空白を含めず、最後の要素の直後にLFまたはEOFを置く。**
各elementの具体的な文法は要素型に従う。

現実装は、各要素が返した消費済み区切りがLF・CR・終端相当なら終了する。
行を構成する `_readWithSeparator()` は単独の `read()` と異なり、区切りを戻さない。
したがって要素行を読んだ後は、行末のLFも消費済みとなる。
先頭空白や空行を保持する物理行パーサではない。
最後の値の後がSP/HTだと、次の要素読取りが改行を飛び越えることがある。
したがって `.strict` も任意の空白を含む物理行を完全に検証するものではない。

| API | 文法・個数制約 |
| --- | --- |
| `[Int]._readLine()`、`Set<Int>._readLine()` など | element-lineの要素列 |
| `read(check:)`（ElementLineReadable） | _readLineと同じ。現在checkによる違いはない |
| `read(columns: n, check: .none)` | element-readをn回。改行をまたげる |
| `read(rows: n, check: .none)`（一次元） | 同上 |
| `read(columns: n, check: .strict)` | element-lineを読み、入力要素数がnか確認 |
| `read(rows: n, check: .strict)`（一次元） | 要素数1のelement-lineをn回 |
| `read(rows: r, columns: c, check:)`（要素列型） | columns読取りをr回合成 |

個数は非負。strictのcolumnsは非空行読みなので、0列の空行を読む機能にはならない。
`ExpressibleByElementSequence` の構築は検査後に行うため、Setの重複排除前の個数を検査する。
二次元は各行の構築後、外側を構築する。返却型が集合なら順序・重複の保持は保証しない。

## 物理行と行内の単語列

```ebnf
line-character = SP | HT | VT | FF | printable ;
line-content = { line-character } ;
physical-line = line-content, (LF | CR, LF)
              | line-character, { line-character }, EOF ;
word-space = SP | HT | VT | FF ;
words-content = { word-space },
                [ token, { word-space, { word-space }, token }, { word-space } ] ;
words-line = words-content, (LF | CR, LF)
           | ? nonempty words-content followed by EOF ? ;
```

物理行読取りは現在位置からLFまでを消費する。改行を取り除き、行内の空白を保持する。
空行は空の結果になる。改行のない最終行も対象とするが、読取り開始時点のEOFとは区別する。
CRLFはこの経路では末尾から両方取り除かれる。単独CRは行境界として統一保証しない。

| API | 文法上の対象 |
| --- | --- |
| String / [Character] / [UInt8] の `read(read: .line)` | physical-line、返すのはline-content |
| それらの配列の `read(rows: r)` | physical-lineをr回 |
| `[String]` / `[[Character]]` / `[[UInt8]]` の `read(read: .words)` | words-lineを読み、tokenの配列にする |
| 上記の `read(read: .words, rows: r)` | words-lineをr回 |
| `[Character].readLine()` / `[UInt8].readLine()` | physical-line。Optionalを返す既存API |
| `stdin(rows: strippingNewline:)` | 既存の行読みの反復。compactMapなので欠けた行を除く |
| `readLine_words()` / `stdin_words()` | 旧経路。tokenをelementとしたelement-line。新しい.wordsとは異なる |

`strippingNewline: false` は改行も返す。
新しい明示的なrows APIは各行を要求する設計で、既存compactMap経路とは同一ではない。
ただし低水準C関数がgetlineの負の戻り値をsize_tで保持している点があり、
EOF・I/Oエラーの全経路は別途検証が必要。ここでは終了時の安全性を検証済みとはしない。

## 固定幅ASCII文字列・一文字

```ebnf
fixed-width-read = { reader-space }, fixed-width-token ;
fixed-width-token = printable, { printable } ;
```

追加制約：fixed-width-tokenのASCIIバイト数がcolumnsと一致し、幅は正。
`String.read(columns:)`、`[Character].read(columns:)`、`[UInt8].read(columns:)` が対応する。
これらの文字列を繰り返すrows:columns:も、同じ操作の合成。
`Character.read()` と `UInt8.read()` は幅1のこの操作に対応する。

現実装は幅分だけ読み、後続を読まない。区切りがなくても、指定幅で続けて分割して読める。
幅に達する前の空白・EOFは従来どおりエラー。失敗時も、その後の余分な一文字を消費しない。
このcolumnsは**文字数（ASCIIバイト数）**であり、数値列のcolumnsは**要素数**。

## 消費規則とプロトコルの対応

文法のelementは入力表記、valueは読取り・変換後のSwift値を指す。
InputElementReadableは区切り報告付きの読み能力、ElementLineReadableはelement-lineの読み能力。
要素行の下位操作は_readLine、物理行の既存操作はreadLineと区別する。
通常はstdin()やread(check:)を利用し、_readLineは入力操作の合成に用いる。
ExpressibleByElementSequenceは読取り後の構築能力であり、対応する解析規則は新設しない。

トークン読取り後に物理行読取りをすると、残した区切りから読み始める。
例えば `1 abc\n` でIntを読むとSPが残るため、次の.lineは ` abc`。
`1\nabc\n` ならLFが残るため、次の.lineは空文字列。その次の.lineで `abc` を読む。
次の行へ進めたい場合は、数値読取り後に現在の行の残りを明示的に読み捨てる。
CRLFでも単独読取りはCRを残す。物理行読取りは続くCRLFをまとめて消費できるが、
要素行の `_readWithSeparator()` は従来どおりCRだけを消費して終了し得る。

| プロトコル | 現在の責任 |
| --- | --- |
| SingleReadable | 一つの値を読む入口。標準の適合型は後続の区切りを残す。文法は適合型次第 |
| InputElementReadable | elementを読み、値と消費済み区切りを返す。区切り報告は文法ではなくAPI契約 |
| ElementLineReadable | 要素を読み、区切りに基づいて行を終える |
| AsciiReadable / AsciiArrayReadable | 一文字・単語・固定幅ASCII入力 |
| ExpressibleByElementSequence | 読取り後の要素配列から構成する。文法解析そのものではない |

`stdin` の多くは `try! read(...)` の入口なので、読める文法は同じでも失敗はthrowで回収できない。
共有バッファと標準入力を使用するため、この文書は単一の読み手を前提とする。

## 品質保証に向けた残件

- 上記の文法・追加制約を正式な保証範囲として採用するか判断する。
- 各生成規則とAPIに対応する既存テストを棚卸しする。直近の関連57件通過は、文法全体の証明ではない。
- 行末空白・空行・CRLF・EOFの経路差を維持するか整理するか判断する。
- 浮動小数点と独自変換型の範囲を別に定義する。
- 要素行の実装共通化は別途検討する。

参照実装：IOReader.swift、InputMode.swift、CheckMode.swift、ElementLineReadable.swift、
Buffer Readable.swift、Word Readable.swift、Ascii Array Readable.swift、Implementations/、
../_FastIO/ReadLine.c。
