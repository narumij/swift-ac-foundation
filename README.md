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
let N: Int = try read()
let (H, W): (Int, Int) = try read()
let (X, Y, Z): (Int, Int, Int) = try read()
let (A, B): (Int, String) = try read()
let (C, D): (Int, [Character]) = try read()
```

```swift
let A = try [Int].readLine()
let G = try [String].readLine()
let H = try [[Character]].readLine()
```

readLine()メソッドは、それぞれ以下とおおよそ等価で、かつ中間のSwift文字列を作成しません

```swift
let A = readLine()!.components(separatedBy: " ").map { Int($0)! }
let G = readLine()!.components(separatedBy: " ").map { $0 }
let H: [[Character]] = readLine()!.components(separatedBy: " ").map { $0.map{ $0 } }
```

#### 細かい話

以下の型に対して、標準入力から空白または改行までを取得する `stdin` プロパティや`read()`メンバー関数を追加します。

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
let T: [Character] = [Character].stdin
let U: [UInt8] = [UInt8].stdin
```

**応用例 1: ペアの入力**  
例えば、問題の入力が `H W` のように並んでいる場合は、次のように記述できます。

```swift
let (H, W): (Int, Int) = try read()
```

```swift
let (H, W): (Int, Int) = (.stdin, .stdin)
```

```swift
let (H, W): (Int, Int) = (try .read(), try .read())
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
let H = [[Character]].stdin(rows: H, columns: W)
let I = [[UInt8]].stdin(rows: H, columns: W)
```

#### 部分利用

IOReader 機能のみを利用したい場合は以下をインポートしてください。

```swift
import IOReader
```

#### `read`と`stdin`

基礎となるメソッドや関数は命名のセオリーに従い、動詞の`read`が識別子に絡んでいます。

それに対して`try`を省ける便利プロパティ、便利メソッドの識別子は`stdin`になっています。

これはC++の`cin`を意識したことが一つあります。

もう一つは、`stdin`識別子をこんな風変わりに使う人は滅多にいないだろうという打算によりこの識別子にしています。

コンテスト中に`ambiguous`を解決するのはかなり困難なので、極力これを避けたいからです。

風変わりな識別子というのは割と忘れやすいものなので、その点でも`stdin`が一番ましという判断をしています。

#### その他

この IOReader は、文字列分割、文字列コピー、数値化の無駄を最小限に抑えるよう設計されています。  
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

let (_, M): (Int, Int) = stdin()
nonisolated(unsafe) var m: [Pack<Int, Int>: Int] = [:]
nonisolated(unsafe) var ans = 0
for _ in 0 ..< M {
  var (u,v): (Int, Int) = stdin()
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

### CharacterUtil

文字列問題では、Swiftの文字列、Characterの配列、UInt8の配列のどれを使うのか選択する必要があります。それぞれに一長一短ありますが、コンテストではCharacterの配列をおすすめしています。

文字の配列を利用する際に困るのが、文字のループを書くのがやや面倒くさいことと、辞書順比較がわかりにくいところです。

このモジュールではまず、ascii文字限定ですが、CharacterにStridableを付与します。

これがどう嬉しいかというと、文字のループが以下のように書けるようになります。

```swift
import AcFoundation

for c: Character in "a"..."z" {
  print(c) // aからzまで順に出力する
}
```

このモジュールでは他に、Characterの配列に辞書順比較を行う比較演算子を追加します。

```swift
import AcFoundation

print(Array("abc") < Array("abd")) // true
```

#### 部分利用

CharacterUtil 機能のみを利用したい場合は以下をインポートしてください。

```swift
import CharacterUtil
```

---

### UInt8Util

文字列問題では、Swiftの文字列、Characterの配列、UInt8の配列のどれを使うのか選択する必要があります。それぞれに一長一短ありますが、コンテストではCharacterの配列をおすすめしています。おすすめしてはいますが、CやC++に慣れてる人にはUInt8の配列のほうが取り扱いが楽だったりもします。0x0端のcString関連メソッドがdeprecatedになりはじめたので、CCharではなく、UInt8を推しています。

UInt8を利用する場合に困るのが、文字定数が使えないことです。本モジュールではこれをカバーする拡張を追加してあり、以下のように書けます。

```swift
let c: UInt8 = "A"
```

本モジュールでは他に、UInt8の配列に辞書順比較を行う比較演算子を追加します。

```swift
print("abc".compactMap(\.asciiValue) < "abd".compactMap(\.asciiValue)) // true
```

UInt8を利用する場合、他に困るのがCharacterにあるような便利メソッドが無いことですが、これはオレオレ実装感が高いのことと、UInt8を選択するレベルの人は自前で用意できると想定していることもあり、これ以上は追加していません。

本モジュールを利用するには個別importが必要です。以下をファイルの割と先頭に記述してください。

```swift
import UInt8Util
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

  @inlinable static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read())
  }
}

extension SIMD3 where Scalar: SingleReadable {

  @inlinable static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}

extension SIMD4 where Scalar: SingleReadable {

  @inlinable static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}
```

---

## ライセンス

このライブラリは CC0-1.0 ライセンスで提供されていますが、一部Apache 2.0 Licenceのコードを含みます。
