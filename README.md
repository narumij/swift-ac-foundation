# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## 利用方法

SwiftPM で `swift-ac-foundation` を利用するには、以下を `Package.swift` に追加します。

タグでの指定はC++でのunsafeFlagsの使用がありビルド拒否となるため、
必要な場合は直接revision指定してください。

```swift
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-foundation", branch: "main"),
]
```

ビルドターゲットに以下を追加します。

```swift
dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]
```

ソースコードに以下を記述してインポートします。

```swift
@preconcurrency import Foundation
import AcFoundation
```

新ジャッジでFoundationとAcFoundationの順番が異なる場合、stderrのprint文利用でCEとなることが確認されています。
ご注意ください。

---

## 内容

### IOReader

#### とりあえず使う場合

```swift
let A = [Int].readLine()!
let G = [String].readLine()!
let H = [[UInt8]].readLine()!
```

それぞれ以下とおおよそ等価で、かつ中間のSwift文字列を作成しません

```swift
let A = readLine()!.split(separator: " ").map { Int($0)! }
let G = readLine()!.split(separator: " ").map { $0 }
let H: [[UInt8]] = readLine()!.split(separator: " ").map { $0.map{ $0.asciiValue! } }
```

#### 細かい話

以下の型に対して、標準入力から空白または改行までを取得する `stdin` プロパティやメンバー関数を追加します。

- 固定長整数
- 浮動小数点数
- 文字列
- 文字配列 (Character)
- C 文字配列 (UInt8)

**入力の区切り**  
空白、タブ、改行を区切り文字として使用します。

```swift
let N: Int = Int.stdin
let D: Double = Double.stdin
let S: String = String.stdin
let T: [UInt8] = [UInt8].stdin
```

**応用例 1: ペアの入力**  
例えば、問題の入力が `H W` のように並んでいる場合は、次のように記述できます。

```swift
let (H, W): (Int, Int) = (.stdin, .stdin)
```

```swift
let (H, W): (Int, Int) = readLine()!
```

```swift
let (H, W): (Int, Int) = try read()
```

**応用例 2: 配列の入力**  
個数 `N` と数列 `A` を入力する場合は以下のように記述します。縦横に並ぶデータにも対応可能です。

```swift
let N: Int = Int.stdin
let A: [Int] = (0..<N).map { .stdin }
```

**応用例 3: クエリの処理**  
クエリ `Q` とそれに応じた入力を処理する例です。

```swift
let Q: Int = Int.stdin
for _ in 0..<Q {
  switch Int.stdin {
    case 1:
      let (A, B) = (Int.stdin, Int.stdin)
      // 処理
    case 2:
      let C = Int.stdin
      // 処理
    default:
      break
  }
}
```

#### 他の便利なメンバー関数

数を指定して読む場合

```swift
let A = [Int].stdin(columns: N)
let G = [String].stdin(rows: H, columns: W)
let H = [[UInt8]].stdin(rows: H, columns: W)
```

#### 部分利用

IOReader 機能のみを利用したい場合は以下をインポートしてください。

```swift
import IOReader
```

#### その他

この IOReader は、データ分割や数値化の無駄を最小限に抑えるよう設計されています。  
数値が多数並んでいる場合、標準の`readLine()` を使用するよりも実行時間を短縮できる場合があります。

一方で、非常に長い文字列を1行丸ごと読み取る場合は、`readLine()` の方が高速です。  
**Swift の文字列操作は AtCoder の問題によって TLE となりやすいため、問題に応じた使い分けを推奨します。**

---

### IOUtil

`print` 関数の `to:` パラメータで `FILE` ポインタを指定できるようになります。  
これにより、以下のような記述が可能です。

```swift
@preconcurrency import Foundation
import AcFoundation

print("Hello, world!", to: &stderr)
```

`Foundation`に`@preconcurrency`を付与しない場合、以下のようになり、CEとなります。

```
 9 | @inlinable
10 | public func Answer() throws {
11 |     print("Hello, STDERR!", to: &stderr)
   |                                  `- error: reference to var 'stderr' is not concurrency-safe because it involves shared mutable state
12 | }
13 | 

SwiftGlibc.stderr:1:12: note: var declared here
1 | public var stderr: UnsafeMutablePointer<FILE>!
  |            `- note: var declared here
```

Xcodeでは`@preconcurrency`の付与なしにコンパイルが通るケースがあり、注意が必要です。

他に、性能を比較したい場合にI/O負荷を軽減する目的で整数専用のfastPrintというものを追加してあります。

#### 部分利用

IOUtil 機能のみを利用したい場合は以下をインポートしてください。

```swift
import IOUtil
```

---

### Bisect

Python の `bisect` を移植したもので、Swift で二分探索を利用可能にします。

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList.bisectLeft(99)) // 3
```

**探索範囲の限定**  
`ArraySlice` を使用することで探索範囲を限定できます。

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList[0..<3].bisectLeft(99)) // 3
```

#### 部分利用

Bisect 機能のみを利用したい場合は以下をインポートしてください。

```swift
import Bisect
```

---

### Pack

SE-283が凍結になっているため、辞書のキーにタプルを使うことは不可能なままのようです。
このため、例えばABC393Cなど、グラフ問題を盆栽なしにSwiftで解こうと思った際、C++のPairに相当するものもないため、
辞書のキーに、都度構造体をかき、Hashable適用をするコードを書く必要が生じます。
カジュアルに競技プログラミングを楽しもうとしている人にそこまでプロトコル知識を要求するのはどうかと思い、用意しました。

これを使うことでABC393Cは以下のようにコンパクトな提出でACできる、予定です。

```swift
import AcFoundation

let (_,M) = (Int.stdin, Int.stdin)
nonisolated(unsafe) var m: [Pack<Int,Int>: Int] = [:]
nonisolated(unsafe) var ans = 0
for _ in 0 ..< M {
  var (u,v) = (Int.stdin, Int.stdin)
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

Comparableにも対応しているため、dijkstraを書く際にも利用できる予定です。

#### 部分利用

Pack 機能のみを利用したい場合は以下をインポートしてください。

```swift
import Pack
```
---

### CxxWrapped

std::gcdとstd::lcmが利用できます。

std::gcdっぽいものではなく、実際にstd::gcdを呼んでいます。

std::lcmっぽいオレオレ実装ではなく、実際にstd::lcmを呼んでいます。

CxxInteropで呼ぶつもりでしたが軽く挫折したため、extern "C"して、C Interopで呼んでいます。


```swift
import AcFoundation

print(gcd(12,16)) // 4

print(lcm(12,16)) // 48

```

#### 部分利用

CxxWrapped 機能のみを利用したい場合は以下をインポートしてください。

```swift
import CxxWrapped
```

---

## その他

2025/06/04以降に公開された新ジャッジで、modintやBigIntをIOReader対応にして利用するには以下のコードが必要です。

```swift
extension static_modint: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

```swift
extension BigInt: IOStringConversionReadable {
  public static func convert(from: String) -> Self { .init(from)! }
}
```

UIntには制限が生じるため、デフォルトで設定がありません。

以下の二つを必要に応じて使い分けてください。

以下の場合、Int.maxまでしか読めません。
```swift
extension UInt: IOReadableInteger { }
```

以下の場合、やや速度が落ちます。
```swift
extension UInt: IOStringConversionReadable {
  static public func convert(from: String) -> UInt { .init(from)! }
}
```

BigIntでの利用にも同様の制限があります。

以下の場合、Int.maxまでしか読めません。
```swift
extension BigInt: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

以下の場合、やや速度が落ちます。
```swift
extension BigInt: IOStringConversionReadable {
  public static func convert(from: String) -> Self { .init(from)! }
}
```

modintは制約次第によっては、以下で速度が多少稼げる予定です。

```swift
extension static_modint: @retroactive IOIntegerConversionReadable {
  // 入力の制約が0からmod未満までの場合のみ利用可
  public static func convert(from: Int) -> Self { .init(rawValue: UInt(bitPattern: from)) }
}
```

他に、SIMDでは以下のようにします。

```swift
extension SIMD2 where Scalar: SingleReadable {
  @inlinable
  static var stdin: Self {
    [Scalar.stdin, Scalar.stdin]
  }
}

extension SIMD3 where Scalar: SingleReadable {
  @inlinable
  static var stdin: Self {
    [Scalar.stdin, Scalar.stdin, Scalar.stdin]
  }
}

extension SIMD4 where Scalar: SingleReadable {
  @inlinable
  static var stdin: Self {
    [Scalar.stdin, Scalar.stdin, Scalar.stdin]
  }
}
```

---

## ライセンス

このライブラリは CC0-1.0 ライセンスで提供されていますが、一部Apache 2.0 Licenceのコードを含みます。
