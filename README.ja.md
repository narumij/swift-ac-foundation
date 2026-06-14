# swift-ac-foundation

[English](README.md) | 日本語

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## 利用方法

SwiftPM プロジェクトで swift-ac-foundation を使用するには、Package.swift ファイルの dependencies に次の行を追加します。

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
   branch: "compatible/AtCoder/2025"),
```

タグでの指定は C++ の `unsafeFlags` の使用によりビルド拒否となる場合があるため、必要な場合は直接 revision を指定してください。

実行可能ターゲットの依存関係に `AcFoundation` を追加してください。

```swift
.target(name: "<target>", dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]),
```

ソースコードに以下を記述してインポートします。

```swift
import AcFoundation
```

## ブランチ方針

| Branch | Recommended | Status | Description |
|---|---|---|---|
| `compatible/AtCoder/2025` | Yes | Maintained | AtCoder 2025 互換の推奨版 |
| `release/AtCoder/2025` | | Frozen | AtCoder 2025 搭載版のスナップショット |
| `main` | | Active Development | 次期リリース開発版 |

### どのブランチを使うべきか

通常は `compatible/AtCoder/2025` を利用してください。

`release/AtCoder/2025` は AtCoder に搭載されている状態をそのまま保存するためのブランチです。原則として変更されません。

`compatible/AtCoder/2025` は AtCoder 2025 との互換性を維持しながら、ドキュメント補強、deprecated 指定、注意喚起の追加などの保守を行うブランチです。

`main` は次期リリースに向けた開発ブランチです。

---

## 内容

`AcFoundation` は `IOReader`, `Bisect`, `Pack`, `CxxWrapped`, `Miscellaneous` を re-export します。
その他のモジュールは個別 import で利用します。

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

単語は半角スペース、タブ、改行などで区切られた入力を想定しています。
文字列と文字は ASCII 入力を前提としています。

詳しい使い方は以下のドキュメントに分けています。

- [IOReader の考え方](Documents/IOReaderConcepts.ja.md): `readLine()` との違いから知りたい場合
- [IOReader の入力例](Documents/IOReaderRecipes.ja.md): 実践的な入力例を見たい場合
- [IOReader リファレンス](Documents/IOReaderReference.ja.md): 対応型や細かい API を確認したい場合

IOReader 機能のみを利用したい場合は、個別に `import IOReader` できます。

---

### IOUtil

IOUtil は低レベルの入出力補助をまとめたモジュールです。
通常の入力には IOReader を使う想定で、IOUtil は個別 import でのみ利用します。

```swift
import IOUtil
```

`fastPrint` は低レベルの出力関数を使って、整数や ASCII 文字列相当の値を出力します。
符号付き整数、符号なし整数、整数の配列、`[UInt8]`, `[Int8]`, `[Character]` に対応しています。

```swift
fastPrint(123)
fastPrint([1, 2, 3])
fastPrint([1, 2, 3], separator: 0x0A)
fastPrint(asciiValues: Array("OK".utf8))
```

`getline` は 1 行を UTF-8 バイト列として扱うための API です。
`readIntLine()` と `readUIntLine()` は、1 行を整数配列として読み取ります。
行バッファの挙動を確認したい場合や、自作 reader の土台がほしい場合に使えます。

```swift
let values: [Int] = readIntLine()
let unsigned: [UInt] = readUIntLine()
```

`FileOutputStream` は `print` 関数の `to:` パラメータで利用できる標準出力と標準エラーの `TextOutputStream` を提供しますが、この互換ブランチでは deprecated です。

```swift
print("debug", to: &FileOutputStream.standardError)
```

---

### Bisect

Python の `bisect` を Swift 向けに移植したものです。
ソート済みの Collection に対して、順序を保ったまま値を挿入できる位置を検索します。

```swift
let sortedList = [1, 4, 8, 100, 1000]

print(sortedList.bisectLeft(99))  // 3
print(sortedList.bisectRight(99)) // 3
```

`bisectLeft(x)` は `x` を同じ値の左側に挿入する位置、`bisectRight(x)` は右側に挿入する位置を返します。
重複値を含む配列では、この差が `x` の出現回数になります。

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
`ArraySlice` に対しても利用できます。
返り値は元のコレクション上のインデックスなので、スライスの `startIndex` が 0 とは限らない点に注意してください。

```swift
let sortedList = [1, 4, 8, 100, 1000]
let slice = sortedList[1..<4]

print(slice.bisectLeft(99)) // 3
```

**ソート順を保った挿入**
`RangeReplaceableCollection` では `insortLeft` / `insortRight` で、探索した位置にそのまま挿入できます。
探索は対数時間ですが、配列への挿入は要素移動を伴うため `O(n)` です。

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
グラフの辺 `(u, v)` や座標 `(x, y)` などを辞書や集合で扱いたい場合、本来は専用の構造体を定義して `Hashable` を実装する必要があります。

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

`Pack` は `Comparable` にも対応しているため、順序付きの比較が必要な場面でも利用できます。

コンパイル環境によって問題が発生する場合は、代わりに `Pack2` や `Pack3` を利用してください。

#### 部分利用

Pack 機能のみを利用したい場合は以下をインポートしてください。

```swift
import Pack
```

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

### Miscellaneous

Miscellaneous は、AtCoder でよくみかける短い定型処理をまとめたモジュールです。
`AcFoundation` からも利用できますが、この機能だけが必要な場合は個別 import できます。

主に、判定結果をそのまま出力文字列へ変換する関数と、整数まわりの小さな補助関数を提供します。

```swift
print(Yes(a == b))       // true なら Yes、false なら No
print(NO(x < y))         // true なら NO、false なら YES
print(Takahashi(win))    // true なら Takahashi、false なら Aoki
```

整数用には、負数を含む割り算で使いやすい `floor` / `ceil` / `mod` と、よく使う法の定数を用意しています。

```swift
print(floor(-3, 2)) // -2
print(ceil(-3, 2))  // -1
print(mod(-3, 2))   // 1

let mod = MOD_998_244_353
```

#### 部分利用

```swift
import Miscellaneous
```

---

### Convenience

Convenience は、提出コードを短く書くための補助モジュールです。
個別 import でのみ利用します。

```swift
import Convenience
```

配列や文字列の繰り返し、リサイズ、累積和、集約処理、範囲ループ、ビット操作など、標準ライブラリだけでも書けるものを短く書くための API を集めています。

```swift
let zeros = [0] * 5              // [0, 0, 0, 0, 0]
let grid = [0] * (3, 4)          // 3 x 4 の 2 次元配列
let text = "ab" * 3             // "ababab"

var a = [1, 2]
a.resize(5)                     // [1, 2, 0, 0, 0]
```

`Sequence` には、出力、合計、積、個数カウント、真偽判定、ビット演算の集約、転置などの補助が追加されます。

```swift
[1, 2, 3].print()
[1, 2, 3].print(separator: ",")

print([1, 2, 3].sum())
print([2, 3, 4].product())
print([true, true].all)
print([false, true].any)
print([1, 2, 1, 3].count(1))

let matrix = [[1, 2, 3], [4, 5, 6]]
print(matrix.transposed())       // [[1, 4], [2, 5], [3, 6]]
```

累積和は 1 次元から 3 次元まで用意しています。

```swift
let s = prefixSum([1, 2, 3])
print(s)                         // [0, 1, 3, 6]

let gridSum = prefixSum([[1, 2], [3, 4]])
```

整数には、べき乗演算子、ループ補助、ビット添字などが追加されます。

```swift
print(2 ** 10)                   // 1024

for i in 0 ..<= 3 {
  print(i)                       // 0, 1, 2, 3
}

for i in 3 ..>= 0 {
  print(i)                       // 3, 2, 1, 0
}

var bit = 0
bit[3] = true
print(bit)                       // 8
```

---

### StringUtil

StringUtil は、Swift の `String` をそのまま利用したい場合のための補助モジュールです。
Swift の文字列は Unicode を考慮した高機能な型であるため、整数の添え字によるアクセスができません。
そのため、競技プログラミングを始めたばかりの人にとっては扱いづらく感じることがあります。

このモジュールを利用すると、整数の添え字や範囲を使って文字列へアクセスできます。

```swift
import StringUtil

let s = "abcdef"

print(s[0])          // "a"
print(s[0..<s.count]) // "abcdef"
print(s[0...])       // "abcdef"
print(s[..<s.count]) // "abcdef"
print(s[2..<4])      // "cd"
print(s[2...])       // "cdef"
print(s[..<4])       // "abcd"
print(s[...4])       // "abcde"
```

ABC の A 問題や B 問題など、まずは素直に実装したい場面での利用を想定しています。
大きな入力や文字列を頻繁に操作する問題では、`[Character]` や `[UInt8]` など別の表現も検討してください。

---

### CharacterUtil

CharacterUtil は、`Character` や `[Character]` を使った実装を少し書きやすくするための補助機能を提供します。

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

このモジュールは個別 import でのみ利用します。

---

### UInt8Util

UInt8Util は、`[UInt8]` を利用する場合に便利な機能を提供します。

Swift では `UInt8` の文字リテラルが存在しないため、ASCII 文字を扱う際に少し不便です。
このモジュールを利用すると、以下のように文字リテラルから `UInt8` を生成できます。

```swift
import UInt8Util

let c: UInt8 = "A"
```

また、`[UInt8]` に対して辞書順比較を行う比較演算子を提供します。

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)

print(abc < abd) // true
```

そのほかにも、ASCII 文字列を扱う際に便利な `Character` 相当の補助機能をいくつか追加しています。

このモジュールは個別 import でのみ利用します。

---

### MT19937

メルセンヌツイスターです。疑似乱数です。
AHC 等で、再現性のある乱数が使いたい場合に利用できます。

```swift
var mt = mt19937_64(seed: 0)
let randomInteger = Int.random(in: Int.min...Int.max, using: &mt)
let randomDouble = Double.random(in: 0...1, using: &mt)
```

個別 import でのみ利用します。

```swift
import MT19937
```

---

## ローカルテスト用の `TestingUtil`

`TestingUtil` は提出コード向けではなく、ローカルのテストコードで使うための補助ターゲットです。
AtCoder などのジャッジ環境には含まれていないため、提出コードには `import TestingUtil` を書かないでください。

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

このライブラリは CC0-1.0 ライセンスで提供されていますが、一部 Apache 2.0 License のコードを含みます。
