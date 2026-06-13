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
手元の入力ライブラリと組み合わせることで、コード量を減らすこともできます。

```swift
let N = Int.stdin
let A = [Int].stdin(columns: N)
let (H, W): (Int, Int) = stdin()
let S = [String].stdin(rows: H, columns: W)
```

単語は半角スペース、タブ、改行などで区切られます。
文字列や文字は ASCII 入力を想定しています。

詳しい使い方は以下のドキュメントに分けています。

- [IOReader の考え方](Documents/IOReaderConcepts.md): `readLine()` との違いから知りたい場合
- [IOReader の入力例](Documents/IOReaderRecipes.md): 実践的な入力例を見たい場合
- [IOReader リファレンス](Documents/IOReaderReference.md): 対応型や細かい API を確認したい場合

IOReader 機能のみを利用したい場合は、個別に `import IOReader` できます。

---

### IOUtil

**stdoutやstderrによる方法は廃止しました**

`print` 関数の `to:` パラメータで利用できる標準出力と標準エラーのTextOutputStremを提供します。
これにより、以下のような記述で標準エラーへの出力が可能になります。

```swift
import Foundation
import IOUtil

print("Hello, world!", to: &FileOutputStream.standardError)
```

他に、性能を比較したい場合にI/O負荷を軽減する目的で整数専用のfastPrintというものを追加してあります。

#### 部分利用

個別importでしか提供していません。

IOUtil 機能を利用したい場合は以下をインポートしてください。

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
辞書のキーに、都度構造体とそれにHashable適用をするコードを書く必要が生じます。
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

Comparableにも対応しているため、dijkstraを書く際にも利用できます。

コンパイルで問題が生じた場合、迂回用のPack2またはPack3もお試しください。

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

本モジュールを利用するには個別importが必要です。以下をソースの割と先頭に記述してください。
(readLine関数の追加で型の記述に不便が生じる懸念があり、一括importから外しました)

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

## その他

modintやBigIntをIOReader対応にして利用するには以下のコードが必要です。

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

制約によっては、以下で速度が多少稼げます。

```swift
// 入力の制約がInt.minからInt.maxまでの場合利用可
extension BigInt: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

```swift
// 入力の制約が0からmod未満までの場合利用可
extension static_modint: @retroactive IOUnsignedIntegerConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: UInt) -> Self { .init(rawValue: from) }
}
```

---

## ライセンス

このライブラリは CC0-1.0 ライセンスで提供されていますが、一部Apache 2.0 Licenceのコードを含みます。
