# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## 内容

### 入力

#### Reader

以下の型に、標準入力から空白または改行までを取り出すstdinプロパティとメンバー関数を付与します。

- 固定長整数
- バイナリ浮動小数
- 文字列
- C文字配列

```swift
let N: Int = .stdin
let A: [Int] = .stdin(columns: N)
let S: String = .stdin
```

```swift
let (H,W): (Int, Int) = (.stdin, .stdin)
let G: [[CChar]] = .stdin(rows: H, columns: W)
```

getchar_unlocked()を用いた読み込みとなっていて、必要最小限しか読みません。
文字の整数化にはatolを用いています。Intのパーサーに渡す文字列を構築する必要がなくなり、この分の実行時間も軽減されています。
つまるところ、作業変数としてSwiftのStringを一切作らない分、高速です。

## Testsに含まれるものについて

盆栽等、どうぞご自由にご利用ください。

## 利用の仕方

SwiftPMで swift-ac-libraryを利用する場合は、

以下をPackage.swift に追加してください。
```
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-foundation.git", from: "0.0.4"),
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

## ライセンス

CC0-1.0

