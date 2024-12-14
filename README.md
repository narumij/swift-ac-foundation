# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## 利用の仕方

SwiftPMで swift-ac-libraryを利用する場合は、

以下をPackage.swift に追加してください。
```
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-foundation.git", from: "0.0.5"),
],
```

ビルドターゲットに以下を追加します。

```
    dependencies: [
      .product(name: "AtCoder", package: "swift-ac-foundation")
    ]
```

ソースコードに以下を追加します。
```
import AcFoundation
```

## 内容

### IOReader

以下の型に、標準入力から空白または改行までを取り出すstdinプロパティとメンバー関数を付与します。

- 固定長整数
- バイナリ浮動小数
- 文字列
- C文字配列

空白または改行を区切り文字として扱います。

```swift
let N: Int = Int.stdin
let N: Double = Double.stdin
let S: String = String.stdin
let T: [UInt8] = [UInt8].stdin
```

応用として、問題の入力が、H Wと並んでる場合に、以下のような書き方ができます。

```swift
let (H,W): (Int, Int) = (.stdin, .stdin)
```

個数Nと、数列Aとを入力で受け取る場合、以下のような書き方ができます。

読む挙動に縦横の区別がないため、縦に並んでいる場合でも同様に読めます。

```swift
let N: Int = Int.stdin
let A: [Int] = (0..<N).map{ .stdin }
```

個数Qと、2種のクエリーを入力で受け取る場合、以下のような書き方ができます。

```swift
let Q: Int = Int.stdin
for _ in 0 ..< Q {
  switch Int.stdin {
    case 1:
      let (A,B) = (Int.stdin, Int.stdin)
      // do something
      break
    case 2:
      let C = Int.stdin
      // do soomething
      break
    default:
      break
  }
}
```

#### 便利メンバー関数

配列や配列の配列を読む便利メンバー関数も追加してあります。

以下のような利用方法が可能です。

```swift
let A: [Int] = .stdin(columns: N)
```

```swift
let G: [[CChar]] = .stdin(rows: H, columns: W)
```

#### 部分利用

この機能だけを用いる場合は、以下のようにすることができます。

```swift
import IOReader
```

#### その他

このIOReaderは、分割をする部分と、数値化する部分の無駄が少なくなるように作られています。
数値が多数並んでいるケースでは、readLine()を用いるより実行時間を削れる場合が多いです。
一方、非常に長い文字列を1行まるまる入力として与えられた場合、readLine()のほうが速いです。

Swiftの文字列を安直に使うと、AtCoderの問題ではTLEとなりやすい傾向があるため、問題に応じて使い分けてください。


### IOUtil

print関数のto:に対して、FILEのポインタを渡せるようになります。
このため、以下のような書き方ができるようになります。

```swift
print("Hello, world!", to: &stderr)
```

#### 部分利用

この機能だけを用いる場合は、以下のようにすることができます。

```swift
import IOUtil
```

### Bisect

pythonのbisectをswiftに移植したもので、二分探索が利用可能になります。

```swift
let sortedList = [1,4,8,100,1000]
print(sortedList.bisectLeft(99))
```

探索の範囲を限定する場合は、以下のようにArraySliceを利用することで可能になります。


```swift
let sortedList = [1,4,8,100,1000]
print(sortedList[0 ..< 3].bisectLeft(99))
```

#### 部分利用

この機能だけを用いる場合は、以下のようにすることができます。

```swift
import Bisect
```

## Testsに含まれるものについて

盆栽等、どうぞご自由にご利用ください。

## ライセンス

CC0-1.0

