# swift-ac-foundation

## 内容

### 入力

#### Reader

以下の型に、標準入力から空白または改行までを取り出すread()メソッドを付与します。

- 固定長整数
- バイナリ浮動小数
- 文字列
- C文字配列

```swift
let N: Int = Int.read()
```

getchar_unlocked()を用いた読み込みとなっていて、必要最小限しか読みません。
文字の整数化にはatolを用いています。Intのパーサーに渡す文字列を構築する必要がなくなり、この分の実行時間も軽減されています。
つまるところ、作業変数としてSwiftのStringを一切作らない分、高速です。

#### ReaderHelper

タプルや配列の入力を補助します。

```swift
let N,M: Int
(N,M) = Input.read()
```

```swift
let N: Int
let A: [Int]
N = Input.read()
A = Input.read(columns: N)
```

## ライセンス

CC0

