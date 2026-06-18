# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

[English](README.md) | 日本語

## 利用方法

SwiftPM プロジェクトで swift-ac-foundation ライブラリを使用するには、Package.swift ファイルの dependencies に次の行を追加します。

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
   branch: "compatible/AtCoder/2025"),
```

タグでの指定はC++でのunsafeFlagsの使用がありビルド拒否となるため、必要な場合は直接revision指定してください。

実行可能ターゲットの依存関係に「AcFoundation」を追加してください。

```swift
.target(name: "<target>", dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]),
```

ソースコードに以下を記述してインポートします。

```swift
import AcFoundation
```

## Branch Strategy

| Branch | Recommended | Status | Description |
|----------|----------|----------|----------|
| `compatible/AtCoder/2025` | ⭐ | Maintained | AtCoder 2025 互換の推奨版 |
| `release/AtCoder/2025` | | Frozen | AtCoder 2025 搭載版 |
| `main` | | Active Development | 次期リリース開発版 |

### Which branch should I use?

通常は `compatible/AtCoder/2025` を利用してください。

`release/AtCoder/2025` は AtCoder に搭載されている状態をそのまま保存するためのブランチです。原則として変更されません。

`compatible/AtCoder/2025` は AtCoder 2025 との互換性を維持しながら、ドキュメント補強、deprecated 指定、注意喚起の追加などの保守を行うブランチです。

`main` は次期リリースに向けた開発ブランチです。

---

## 内容

### IOReader

IOReader は入力値を単語単位で取得する入力ライブラリです。
入力コードを非常に簡潔に記述できるため、問題本体に集中しやすくなります。
`readLine()` ベースの入力と比べて、中間文字列や分割処理のコストを抑えられます。
お手元の入力ライブラリと組み合わせることで、コード量を減らすこともできます。

```swift
let N = Int.stdin
let A = [Int].stdin(columns: N)
let (H, W): (Int, Int) = stdin()
let S = [String].stdin(rows: H, columns: W)
```

token は半角スペース、タブ、改行などの空白文字で区切られます。
文字列や文字は ASCII 入力を想定しています。

詳しい使い方は以下のドキュメントに分けています。

- [IOReader の考え方](Documents/IOReaderConcepts.ja.md): `readLine()` との違いから知りたい場合
- [IOReader の入力例](Documents/IOReaderRecipes.ja.md): 実践的な入力例を見たい場合
- [IOReader リファレンス](Documents/IOReaderReference.ja.md): 対応型や細かい API を確認したい場合

IOReader 機能のみを利用したい場合は、個別に `import IOReader` できます。

---

### IOReaderExtra

IOReaderExtra は、外部ライブラリ、新しめの実行環境、追加モジュールに依存する型へ `stdin` 対応を追加します。
利用する場合は個別 import が必要です。

```swift
import BigInt
import IOReaderExtra
import Pack

let x = BigInt.stdin
let a: Pack2<Int, String> = .stdin
let v = SIMD3<Int>.stdin
```

| 型 | 補足 |
|---|---|
| `BigInt` | 10 進文字列として読み取ります |
| `Int128`, `UInt128` | macOS 15.0 以降で利用できます |
| `static_modint`, `dynamic_modint` | AtCoder の modint 型です |
| `Pack`, `Pack2`, `Pack3` | 中身の型が `stdin` 対応の場合に利用できます |
| `SIMD2`, `SIMD3`, `SIMD4` | `Scalar` が `stdin` 対応の場合に利用できます |
| `InlineArray` | macOS 26.0 以降、`Element` が `stdin` 対応の場合に利用できます |

---

### IOWriter

IOWriter は、配列を 1 行に、配列の配列を複数行に整形して出力する `print` メソッドを提供するモジュールです。

数値配列は空白区切りで、文字配列は連結して出力します。

```swift
[1, 2, 3].print()        // 1 2 3
[1.5, 2.5].print()       // 1.5 2.5
(["A", "B", "C"] as [Character]).print() // ABC
```

配列の配列は、各要素を 1 行ずつ出力します。

```swift
[[1, 2], [3, 4]].print()
// -> 1 2
//    3 4
```

```swift
([["#", "#"], ["#", "#"]] as [[Character]]).print()
// -> ##
//    ##
```

標準の `print` 関数と同様に、区切り文字や終端文字も指定できます。

```swift
[1.5, 2.5].print(separator: ", ") // 1.5, 2.5
```

配列の配列では、区切り文字や終端文字は各行に適用されます。

```swift
[[1, 2], [3, 4]].print(separator: ", ")
// -> 1, 2
//    3, 4
```

macOS 26.0 以降では、`InlineArray` に対しても `print(separator:terminator:)` が利用できます。

#### 部分利用

```swift
import IOWriter
```

---

### IOUtil

IOUtil は、ベンチマーク結果が入出力コストに支配されにくいようにするための高速 I/O 補助と、自作の入出力処理を組み立てるための低レベル部品を提供します。
通常の競技用途で使う主な入力 API ではありません。利用する場合は個別 import が必要です。

```swift
import IOUtil
```

`fastPrint` は低レベルの出力関数を使って、整数や ASCII 文字列相当の値を出力します。
符号付き整数、符号なし整数、整数の collection、`[UInt8]`、`[Int8]`、`[Character]` に対応しています。

```swift
fastPrint(123)
fastPrint([1, 2, 3])
fastPrint([1, 2, 3], separator: 0x0A)
fastPrint(asciiValues: Array("OK".utf8))
```

`CustomStringConvertible` に準拠した要素の sequence は、区切り文字付きで出力できます。

```swift
[1, 2, 3].print()
[1, 2, 3].print(separator: ",")
```

`withUnsafeReadLineBytes` は 1 行を UTF-8 バイト列として扱うための API です。
行バッファの挙動を確認したい場合や、自作 reader の土台がほしい場合に使えます。

```swift
try withUnsafeReadLineBytes { line in
  String(decoding: line, as: UTF8.self)
}
```

`stderr` と `stdout` は `TextOutputStream` の出力先としても利用できます。

```swift
print("debug", to: &stderr)
```

---

### Bisect

Python の bisect を Swift 向けに移植したものです。ソート済みの Collection に対して、順序を保ったまま値を挿入できる位置を高速に検索します。

具体的には、指定した値以上の要素が最初に現れる位置 (bisectLeft) と、指定した値より大きい要素が最初に現れる位置 (bisectRight) を返します。

```swift
let sortedList = [1, 4, 8, 100, 1000]

print(sortedList.bisectLeft(99))  // 3: 99 未満の要素数
print(sortedList.bisectRight(99)) // 3: 99 以下の要素数
```

`bisectLeft(x)` は `x` を同じ値の左側に挿入する位置、`bisectRight(x)` は右側に挿入する位置を返します。重複値を含む配列では、この差が `x` の出現回数になります。

```swift
let values = [1, 2, 2, 2, 5]

let left = values.bisectLeft(2)
let right = values.bisectRight(2)

print(left)          // 1
print(right)         // 4
print(right - left)  // 3
```

要素そのものではなく、要素から取り出した値で比較したい場合は `key` を渡せます。

```swift
let pairs = [(score: 10, name: "a"), (score: 20, name: "b"), (score: 20, name: "c")]

print(pairs.bisectLeft(20) { $0.score })  // 1
print(pairs.bisectRight(20) { $0.score }) // 3
```

**探索範囲の限定**  
`ArraySlice` や `Range` に対しても利用できます。返り値は元のコレクション上のインデックスなので、スライスの `startIndex` が 0 とは限らない点に注意してください。

```swift
let sortedList = [1, 4, 8, 100, 1000]
let slice = sortedList[1..<4]

print(slice.bisectLeft(99)) // 3
```

**ソート順を保った挿入**  
`RangeReplaceableCollection` では `insortLeft` / `insortRight` で、探索した位置にそのまま挿入できます。挿入自体は配列の要素移動を伴うため `O(n)` です。

```swift
var values = [1, 2, 2, 5]
values.insortRight(2)

print(values) // [1, 2, 2, 2, 5]
```

#### 部分利用

Bisect 機能のみを利用したい場合は以下をインポートしてください。

```swift
import Bisect
```

---

### Pack

Swift ではタプルをそのまま辞書のキーとして利用できません。

そのため、グラフの辺 `(u, v)` や座標 `(x, y)` などを辞書や集合で扱いたい場合、本来は専用の構造体を定義して `Hashable` を実装する必要があります。

`Pack` はその手間を省くための型です。

```swift
var edges: [Pack<Int, Int>: Int] = [:]

edges[.init(1, 2), default: 0] += 1
edges[.init(2, 3), default: 0] += 1
```

例えば ABC393C では、辺の重複を数えるために以下のように利用できます。

```swift
import AcFoundation

let (_, M): (Int, Int) = stdin()

nonisolated(unsafe) var m: [Pack<Int, Int>: Int] = [:]
nonisolated(unsafe) var ans = 0

for _ in 0 ..< M {
  var (u, v): (Int, Int) = stdin()

  if u == v {
    ans += 1
    continue
  }

  if u > v {
    swap(&u, &v)
  }

  m[.init(u, v), default: 0] += 1
}

m.forEach {
  ans += $0.value - 1
}

print(ans)
```

`Pack` は `Comparable` にも対応しているため、優先度付きキューやダイクストラ法など、順序付きの比較が必要な場面でも利用できます。

コンパイル環境によって問題が発生する場合は、代わりに `Pack2` や `Pack3` を利用してください。

#### 部分利用

Pack 機能のみを利用したい場合は以下をインポートしてください。

```swift
import Pack
```

---

### StringUtil

文字列問題では `String`、`[Character]`、`[UInt8]` など様々な表現方法があります。

`StringUtil` は、その中でも Swift の `String` をそのまま利用したい場合のための補助モジュールです。
利用する場合は個別 import が必要です。

```swift
import StringUtil
```

Swift の文字列は Unicode を考慮した高機能な型であるため、整数の添え字によるアクセスができません。

そのため、競技プログラミングを始めたばかりの人にとっては扱いづらく感じることがあります。

このモジュールを利用すると、整数の添え字や範囲を使って文字列へアクセスできます。

```swift
let s = "abcdef"

// 1文字取得
print(s[0]) // "a"

// 部分文字列取得
print(s[0..<s.count]) // "abcdef"
print(s[0...])        // "abcdef"
print(s[..<s.count])  // "abcdef"

print(s[2..<4]) // "cd"
print(s[2...])  // "cdef"
print(s[..<4])  // "abcd"
print(s[...4])  // "abcde"
```

ABC の A 問題や B 問題など、まずは素直に実装したい場面での利用を想定しています。

一方で、Swift の `String` は高機能である分、`[Character]` や `[UInt8]` と比較すると処理コストが高くなる場合があります。

大きな入力や文字列を頻繁に操作する問題では、別の表現を検討してください。

文字列問題でどの表現を利用するかは、問題や好みによって異なります。

そのため、`String` 向けの機能は個別 import としています。

---

### CharacterUtil

文字列問題では、`String`、`[Character]`、`[UInt8]` のいずれを利用するか選ぶ必要があります。

それぞれに長所と短所がありますが、本ライブラリでは扱いやすさを重視して `Character` の配列を利用することを想定しています。

`CharacterUtil` は、`Character` や `[Character]` を使った実装を少し書きやすくするための補助機能を提供します。
利用する場合は個別 import が必要です。

まず、ASCII 文字に対して `Character` を範囲で扱えるようにします。

```swift
import CharacterUtil

for c: Character in "a"..."z" {
  print(c)
}
```

これにより、アルファベットや数字の列挙を簡潔に記述できます。

また、`[Character]` に対して辞書順比較を行う比較演算子を提供します。

```swift
import CharacterUtil

print(Array("abc") < Array("abd")) // true
```

文字列を配列へ変換して扱う実装でも、文字列と同じ感覚で辞書順比較を利用できます。

文字列問題では `String` を使う人もいれば、`[Character]` や `[UInt8]` を使う人もいます。

本ライブラリでは利用者が自由に選択できるよう、`Character` 向けの機能は個別 import としています。

---

### UInt8Util

文字列問題では `String`、`[Character]`、`[UInt8]` など様々な表現方法があります。

`UInt8Util` は、その中でも `[UInt8]` を利用する場合に便利な機能を提供します。
利用する場合は個別 import が必要です。

```swift
import UInt8Util
```

Swift では `UInt8` の文字リテラルが存在しないため、ASCII 文字を扱う際に少し不便です。

このモジュールを利用すると、以下のように文字リテラルから `UInt8` を生成できます。

```swift
let c: UInt8 = "A"
```

また、`[UInt8]` に対して辞書順比較を行う比較演算子を提供します。

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)

print(abc < abd) // true
```

そのほかにも、ASCII 文字列を扱う際に便利な `Character` 相当の補助機能をいくつか追加しています。

文字列問題でどの表現を利用するかは、問題や好みによって異なります。

そのため、`UInt8` 向けの機能は個別 import としています。

---

### Miscellaneous

Miscellaneous は、AtCoderでよくみかける短い定型処理をまとめたモジュールです。
`AcFoundation` からも利用できますが、この機能だけが必要な場合は個別 import できます。

主に、判定結果をそのまま出力文字列へ変換する関数と、整数まわりの小さな補助関数を提供します。

```swift
print(Yes(a == b))       // true なら Yes、false なら No
print(NO(x < y))         // true なら NO、false なら YES
print(Takahashi(win))    // true なら Takahashi、false なら Aoki
print(correct(ok))       // true なら correct、false なら incorrect
```

勝ち・負け・引き分けの 3 状態を扱いたい場合は `Bool?` を利用できます。

```swift
let result: Bool? = nil
print(TakahashiAokiDraw(result)) // Draw
```

整数用には、負数を含む割り算で使いやすい `floor` / `ceil` / `mod` と、よく使う法の定数を用意しています。

```swift
print(floor(-3, 2)) // -2
print(ceil(-3, 2))  // -1
print(mod(-3, 2))   // 1

let mod = MOD_998_244_353 // AtCoder Library でよく使われる法
```

#### 部分利用

```swift
import Miscellaneous
```

---

### Convenience

Convenience は、提出コードを短く書くための補助モジュールです。
利用する場合は個別 import が必要です。

```swift
import Convenience
```

配列や文字列の繰り返し、累積和、集約処理、範囲ループ、ビット操作など、標準ライブラリだけでも書けるものを短く書くための API を集めています。

```swift
let zeros = [0] * 5              // [0, 0, 0, 0, 0]
let grid = [0] * (3, 4)          // 3 x 4 の 2 次元配列
let text = "ab" * 3              // "ababab"

var a = [1, 2]
a.resize(5, 0)                   // [1, 2, 0, 0, 0]
```

`Sequence` には、合計・積・個数カウント・転置などの補助が追加されます。

```swift
print([1, 2, 3].sum())           // 6
print([2, 3, 4].product())       // 24
print([true, true].all)          // true
print([false, true].any)         // true
print([1, 2, 1, 3].count(1))     // 2

let matrix = [[1, 2, 3], [4, 5, 6]]
print(matrix.transposed())       // [[1, 4], [2, 5], [3, 6]]
```

累積和は 1 次元から 3 次元まで用意しています。

1 次元の累積和は `swift-algorithms` の `reductions(0, +)` が利用できる場合は、そちらも検討してください。

```swift
let s = prefixSum([1, 2, 3])
print(s)                         // [0, 1, 3, 6]

// swift-algorithms
let t = [1, 2, 3].reductions(0, +)
print(Array(t))                  // [0, 1, 3, 6]

let gridSum = prefixSum([[1, 2], [3, 4]])
```

整数には `range` と `rep`、べき乗演算子、ビット添字などが追加されます。

```swift
for i in 5.range {
  print(i)                       // 0 から 4
}

let squares = 5.rep { i in i * i }
print(2 ** 10)                   // 1024

var bit = 0
bit[3] = true
print(bit)                       // 8
```

降順ループや、終端を含むループ用の演算子もあります。

```swift
for i in 0 ..<= 3 {
  print(i)                       // 0, 1, 2, 3
}

for i in 3 ..>= 0 {
  print(i)                       // 3, 2, 1, 0
}
```

空の範囲も安全に扱えるため、ループ条件を気にせず記述できます。

---

### CxxWrapped

C++ 標準ライブラリの `std::gcd` と `std::lcm` を Swift から利用するためのラッパーです。

独自実装ではなく、実際に C++ 標準ライブラリの `std::gcd` および `std::lcm` を呼び出します。

```swift
import AcFoundation

print(gcd(12, 16)) // 4
print(lcm(12, 16)) // 48
```

現在は C++ 側で `extern "C"` を経由し、Swift から C Interop を利用して呼び出しています。

#### 部分利用

CxxWrapped 機能のみを利用したい場合は以下をインポートしてください。

```swift
import CxxWrapped
```

---

### MT19937

メルセンヌツイスターです。疑似乱数です。
AHC等で、再現性のある乱数が使いたい場合にご利用ください。
利用する場合は個別 import が必要です。

```swift
import MT19937

var mt = mt19937_64(seed: 0)
let randomInteger = Int.random(in: Int.min...Int.max, using: &mt)
let randomDouble = Double.random(in: 0...1, using: &mt)
```

---

## ローカルテスト用の `TestingUtil`

`TestingUtil` は提出コード向けではなく、ローカルのテストコードで使うための補助ターゲットです。

提出用の `solve()` 関数をテストコードから実行し、標準入力を渡して標準出力を文字列として検証する用途を想定しています。

```swift
.testTarget(name: "<test-target>", dependencies: [
  .product(name: "TestingUtil", package: "swift-ac-foundation")
])
```

```swift
import TestingUtil
import XCTest

final class SolverTests: XCTestCase {
  func testSample() throws {
    let runner = SolverRunner {
      solve()
    }

    XCTAssertEqual(try runner.run(input: "3\n1 2 3\n"), "6")
  }
}
```

---

## ライセンス

このライブラリは CC0-1.0 ライセンスで提供されていますが、一部Apache 2.0 Licenceのコードを含みます。
