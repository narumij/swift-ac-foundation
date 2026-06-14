# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

[English](README.md) | 日本語

## 利用方法

SwiftPM プロジェクトで swift-ac-foundation ライブラリを使用するには、Package.swift ファイルの dependencies に次の行を追加します。

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
   branch: "release/AtCoder/2025"),
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

単語とは半角スペース、タブ、改行などで区切られた単独または連続したASCII文字を想定しています。

詳しい使い方は以下のドキュメントに分けています。

- [IOReader の考え方](Documents/IOReaderConcepts.ja.md): `readLine()` との違いから知りたい場合
- [IOReader の入力例](Documents/IOReaderRecipes.ja.md): 実践的な入力例を見たい場合
- [IOReader リファレンス](Documents/IOReaderReference.ja.md): 対応型や細かい API を確認したい場合

IOReader 機能のみを利用したい場合は、個別に `import IOReader` できます。

---

### IOReaderExtra

IOReaderExtra は、外部ライブラリ、新しめの実行環境、追加モジュールに依存する型へ `stdin` 対応を追加します。
`AcFoundation` からは re-export していないため、これらの型を標準入力から直接読みたい場合に個別 import します。

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

### IOUtil

IOUtil は、出力の便利メソッドと、入出力に関する補助的な内容となっています。
個別 import でのみ利用できます。

```swift
import IOUtil
```

まず、Sequenceプロトコルのextensionでprintメソッドが用意されていてます。
これは配列等を空白区切りで出力するものです。

```swift
let A = [1, 2, 3, 4]
A.print() // -> 1 2 3 4
```

InlineArrayにも同様のextentionが用意されており、以下のように出力することができます。

```swift
let A: [4 of Int] = [1, 2, 3, 4]
A.print() // -> 1 2 3 4
```

任意の区切り文字や終端文字を使うことも可能です。
```swift
[1, 2, 3].print(terminator: " ") // 行の前半を出力
[4, 5, 6].print() // 行の後半を出力
// -> 1 2 3 4 5 6
```

```swift
[1, 2, 3].print(separator: "-")
```

FILEポインタが`TextOutputStream` 適合となります。
これにより、`stderr` や `stdout` をprint関数の出力先引数として用いる事ができます。

```swift
#if os(Linux)
@preconcurrency import Glibc
#else
@preconcurrency import Darwin
#endif

print("debug", to: &stderr)
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

### CharacterUtil

文字列問題では、`String`、`[Character]`、`[UInt8]` のいずれを利用するか選ぶ必要があります。

それぞれに長所と短所がありますが、本ライブラリでは扱いやすさを重視して `Character` の配列を利用することを想定しています。

`CharacterUtil` は、`Character` や `[Character]` を使った実装を少し書きやすくするための補助機能を提供します。

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

#### 利用方法

このモジュールは個別に import する必要があります。

```swift
import CharacterUtil
```

`AcFoundation` には含まれていません。

文字列問題では `String` を使う人もいれば、`[Character]` や `[UInt8]` を使う人もいます。

本ライブラリでは利用者が自由に選択できるよう、`Character` 向けの機能は個別 import としています。

---

### UInt8Util

文字列問題では、Swiftの文字列、Characterの配列、UInt8の配列のどれを使うのか選択する必要があります。それぞれに一長一短ありますが、コンテストではCharacterの配列をおすすめしています。おすすめしてはいますが、CやC++に慣れてる人にはUInt8の配列のほうが取り扱いが楽だったりもします。0x0端のcString関連メソッドがdeprecatedになりはじめたので、CCharではなく、UInt8を推しています。

UInt8を利用する場合に困るのが、文字定数が使えないことです。本モジュールではこれをカバーする拡張を追加してあり、以下のように書けます。

```swift
let c: UInt8 = "A"
```

本モジュールでは他に、UInt8の配列に辞書順比較を行う比較演算子を追加します。

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)
print(abc < abd) // true
```

Characterのプロパティ相当のものもいくつか追加してあります。

本モジュールを利用するには個別importが必要です。以下をソースの割と先頭に記述してください。

```swift
import UInt8Util
```

---

### StringUtil

文字列問題では、Swiftの文字列、Characterの配列、UInt8の配列のどれを使うのか選択する必要があります。それぞれに一長一短ありますが、コンテストではCharacterの配列をおすすめしています。おすすめしてはいますが、不慣れな人にこれを強いるのは酷だろうし、かといってSwiftの文字列は整数の添え字が使えず、ここが初心者泣かせなので、文字列に便利メソッドを用意しました。あくまで初心者用であることをご承知の上お使いください。Swiftの文字列はリッチが過ぎるため、競技プログラミングではTLEになりやすいです。この点も併せてご承知ください。

ABCのA問題B問題ぐらいは楽に書きたい、といった場合にどうぞ。

```swift
let s = "abcdef"
// 1文字取得
print(s[0]) // "a"

// 文字列取得
print(s[0..<s.count]) // "abcdef"
print(s[0..<s.count]) // "abcdef"
print(s[0...]) // "abcdef"
print(s[..<s.count]) // "abcdef"
print(s[2..<4]) // "cd"
print(s[2...]) // "cdef"
print(s[..<4]) // "abcd"
print(s[...4]) // "abcde"
```

本モジュールを利用するには個別importが必要です。以下をソースの割と先頭に記述してください。

```swift
import StringUtil
```

---

### Miscellaneous

これ以外の分類で浮いてしまっているものたちです。

#### 部分利用

```swift
import Miscellaneous
```

---

### Convinience

横着用です。個別importでしか提供していません。

```swift
import Convinience
```

---

### MT19937

メルセンヌツイスターです。疑似乱数です。
AHC等で、再現性のある乱数が使いたい場合にご利用ください。

```swift
var mt = mt19937_64(seed: 0)
let randomInteger = Int.random(in: Int.min...Int.max, using: &mt)
let randomDouble = Double.random(in: 0...1, using: &mt)
```

個別importでしか提供していません。

```swift
import MT19937
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
