# IOReader リファレンス

[English](IOReaderReference.md) | 日本語

この文書は `main` の現行APIを対象とします。AtCoder 2025互換ブランチとは、行の検査や区切りの扱いが異なります。

(IOReader の入力例は[こちら](IOReaderRecipes.ja.md)をどうぞ。)

ここでは、IOReader が提供している入力 API を、実際に使う具体型ベースで整理します。

## 入力の区切り

IOReader は標準入力を空白区切りの token として読みます。
半角スペース、改行、タブなどで区切られた値を順に取得できます。

文字列や文字は ASCII 入力を想定しています。

競技中は、型に生えた `stdin` プロパティや `stdin(...)` メソッドで入力を読みます。

## 1 token を読む

```swift
static var stdin: Self { get }
```

数値・文字列は次の token を、`Character`・`UInt8` は空白を飛ばした後の 1 文字を読みます。
`Character.stdin` を連続して呼ぶと、`ABC` から `A`、`B`、`C` を順に取得できます。

```swift
let n = Int.stdin
let x = Double.stdin
let s = String.stdin
let c = Character.stdin
let b = UInt8.stdin
```

### 対応型

| 分類 | 型 |
|---|---|
| 符号付き整数 | `Int`, `Int16`, `Int32`, `Int64`, `Int128` |
| 符号なし整数 | `UInt`, `UInt16`, `UInt32`, `UInt64`, `UInt128` |
| 浮動小数 | `Float`, `Double` |
| 文字列 | `String`, `[Character]`, `[UInt8]` |
| 1 文字 | `Character`, `UInt8` |

`Int128`・`UInt128` は macOS 15.0 以降で利用できます。`CInt`・`CLongLong` 等の対応する型エイリアスも使えます。

`UInt8.stdin` は数値ではなく ASCII 文字 1 文字として読みます。
数値の `8` を整数として読みたい場合は、`Int.stdin` などを使ってください。

## 数値配列を固定個数読む

```swift
static func stdin(columns: Int) -> [Element]
static func stdin(rows: Int) -> [Element]
```

`columns` は 1 行に並ぶ値の個数、`rows` は 1 行に 1 値ずつ読む行数です。
`columns` の途中で行が終わる場合や、指定数を読んだ後に同じ行の値が残る場合は停止します。
`rows` では各値の直後が改行または EOF であることを確認します。

```swift
let a: [Int] = .stdin(columns: 3)
let b: [Double] = .stdin(rows: 3)
```

対応する要素型は以下です。

| 分類 | 要素型 |
|---|---|
| 符号付き整数 | `Int`, `Int16`, `Int32`, `Int64`, `Int128` |
| 符号なし整数 | `UInt`, `UInt16`, `UInt32`, `UInt64`, `UInt128` |
| 浮動小数 | `Float`, `Double` |

## 固定サイズの 2 次元配列を読む

```swift
static func stdin(rows: Int, columns: Int) -> [[Element]]
```

各行に `columns` 個の値が並ぶ入力を `rows` 行読み、`[[Element]]` で返します。

```swift
let grid: [[Int]] = .stdin(rows: 2, columns: 3)
```

対応する要素型は、固定個数の数値配列と同じです。

## 固定長 ASCII 列を読む

`String`, `[Character]`, `[UInt8]` は、固定長の ASCII 文字列を読む API を持ちます。

```swift
static func stdin(columns: Int) -> Self
```

`columns` で指定した ASCII 文字数を読みます。
途中に空白や改行があると失敗します。
指定した文字数だけ読み、直後の文字や区切りは消費しません。
例えば入力 `abcde` に対して `String.stdin(columns: 3)`、`String.stdin(columns: 2)` と続けると、`"abc"`、`"de"` が得られます。

```swift
let s = String.stdin(columns: 5)
let chars: [Character] = .stdin(columns: 5)
let bytes: [UInt8] = .stdin(columns: 5)
```

`String.stdin` や `[UInt8].stdin` は空白までを読む token 入力です。
一方、`stdin(columns:)` は空白を含まない固定長入力です。

## ASCII 文字列の配列を読む

`String` の配列では、戻り値は `[String]` です。

```swift
static func stdin(rows: Int) -> [String]
static func stdin(rows: Int, columns: Int) -> [String]
```

```swift
let s: [String] = .stdin(rows: h)
let fixed: [String] = .stdin(rows: h, columns: w)
```

`[Character]` と `[UInt8]` の配列では、戻り値は 2 次元配列です。

```swift
static func stdin(rows: Int) -> [[Character]]
static func stdin(rows: Int, columns: Int) -> [[Character]]

static func stdin(rows: Int) -> [[UInt8]]
static func stdin(rows: Int, columns: Int) -> [[UInt8]]
```

```swift
let chars: [[Character]] = .stdin(rows: h)
let bytes: [[UInt8]] = .stdin(rows: h, columns: w)
```

| 呼び出し | 戻り値 |
|---|---|
| `[String].stdin(rows:)` | `[String]` |
| `[String].stdin(rows:columns:)` | `[String]` |
| `[[Character]].stdin(rows:)` | `[[Character]]` |
| `[[Character]].stdin(rows:columns:)` | `[[Character]]` |
| `[[UInt8]].stdin(rows:)` | `[[UInt8]]` |
| `[[UInt8]].stdin(rows:columns:)` | `[[UInt8]]` |

`rows:` は空白と空行を保持した行読みです。`rows:columns:` は空白を含まない固定幅の盤面向けです。

## 行末まで token を読む

```swift
static func stdin() -> [Element]
```

行末または EOF まで、空白区切りの token を読みます。
行末の空白を読み飛ばし、改行または EOF に到達したところで停止します。
値のない空行を保持する用途には、次の行読み API を使ってください。

```swift
let a: [Int] = .stdin()
let words: [String] = .stdin()
```

対応する要素型は以下です。

| 分類 | 要素型 |
|---|---|
| 符号付き整数 | `Int`, `Int16`, `Int32`, `Int64`, `Int128` |
| 符号なし整数 | `UInt`, `UInt16`, `UInt32`, `UInt64`, `UInt128` |
| 浮動小数 | `Float`, `Double` |
| 文字列 | `String`, `[Character]`, `[UInt8]` |

## 空白を含む 1 行を読む

`String.readLine()`、`[Character].readLine()`、`[UInt8].readLine()` は空白を含む行全体を読み、末尾の改行を取り除きます。
空行は空の値を返します。戻り値は Optional ではなく、読み取る行がない EOF では停止します。
`strippingNewline` 引数はありません。

```swift
let line = String.readLine()
let lineChars = [Character].readLine()
let lineBytes = [UInt8].readLine()
```

## タプルを読む

```swift
func stdin<each T: Component>() -> (repeat each T)
```

`Component` に準拠した型のタプルを、同じ行から一括で読みます。途中で行が終わると停止します。

```swift
let (n, m): (Int, Int) = stdin()
let (s, x): (String, Double) = stdin()
```

## IOReader 本体で読める固定サイズの組

`SIMD2`・`SIMD3`・`SIMD4` は各スカラー型が `Component` に準拠するとき、同じ行から値を読みます。
`InlineArray` も IOReader 本体に含まれます。macOS 26.0 以降で、要素型が `Component` に準拠する場合に利用できます。要素数が行の値の個数と一致する必要があります。

```swift
let pair = SIMD2<Int>.stdin
let triple: InlineArray<3, Int> = .stdin
```

## IOReaderExtra で増える型

`IOReaderExtra` を import すると、以下の型でも `stdin` が使えます。

| 型 | 条件 |
|---|---|
| `Pack2`, `Pack3`, `Pack4` | 各型が `Component` に準拠 |
| `Pack` | macOS 14.0 以降、各型が `Component` に準拠 |

例:

```swift
import IOReaderExtra
import Pack

let a: Pack2<Int, String> = .stdin
```

## 発展: 独自型対応

独自型を入力対応にしたい場合は、`IOConversion` に準拠して `read()` を実装します。
通常の利用では、上で挙げた具体型を使えば十分です。

ここでの `read()` は直接呼ぶためではなく、`stdin` を使えるようにするための実装です。
`read()` の中では、`readTuple()` で値を読み、独自型を作ります。

```swift
import AcFoundation

struct Edge {
  let u: Int
  let v: Int
  let w: Int
}

extension Edge: IOConversion, Group {
  static func read() throws -> (value: Edge, separator: UInt8?) {
    try readTuple { (value: (Int, Int, Int)) in
      Edge(u: value.0, v: value.1, w: value.2)
    }
  }
}

let edge = Edge.stdin
let edges = [Edge].stdin(rows: 3)
```

`read()` と `readTuple()` は `(value: ..., separator: UInt8?)` を返します。クロージャでは値だけを変換し、セパレータは `readTuple` が行イテレータへ引き継ぎます。`nil` は EOF を表します。

`readTuple()` は、すべての値を同じ行から読みます。読み終わる前に行が終わると停止します。
`Group` にも準拠すると、`stdin` と、1 行に 1 つずつ読む `stdin(rows:)` が使えます。

`readTuple()` は値を 1 つだけ読むこともできます。
1 token から読む型は、`Group` の代わりに `IOReader.Numeric` に準拠します。`stdin` と `stdin(columns:)` が使えます。
`Swift.Numeric` と同じ名前なので、モジュール名を付けて `IOReader.Numeric` と書きます。

複数の型から作れる型では、`as` でどの型として読むかを決めます。

```swift
import AcFoundation

struct Label {
  let value: String

  init(_ value: Int) {
    self.value = String(value)
  }

  init(_ value: String) {
    self.value = value
  }
}

extension Label: IOConversion, IOReader.Numeric {
  static func read() throws -> (value: Label, separator: UInt8?) {
    try readTuple { (value: Int) in Label(value) }
  }
}

let label = Label.stdin
```

## 失敗時の扱い

`stdin` 系は、競技プログラミングの制約どおりに入力が与えられる前提で使う API です。
入力が足りない場合や、固定長文字列の途中に空白が入る場合などは実行時エラーになります。
