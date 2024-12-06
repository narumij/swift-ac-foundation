# swift-ac-foundation

## 内容

### 入力

#### Reader

以下の型に、標準入力から空白または改行までを取り出すstdinメンバーを付与します。

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

## ライセンス

CC0-1.0

