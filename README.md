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
let N: Int = .read()
let A: [Int] = .read(columns: N)
let S: String = .read()
```

```swift
let (H,W): (Int, Int) = (.read(), .read())
let G: [[CChar]] = .read(rows: H, columns: W)
```

getchar_unlocked()を用いた読み込みとなっていて、必要最小限しか読みません。
文字の整数化にはatolを用いています。Intのパーサーに渡す文字列を構築する必要がなくなり、この分の実行時間も軽減されています。
つまるところ、作業変数としてSwiftのStringを一切作らない分、高速です。

#### ReaderHelper

タプルの入力を補助します。

```swift
let N,M: Int
(N,M) = Input.read()
```

### 二分探索

競技関連のリポジトリに様々二分探索の実装がありますが、こちらはPython風になっています。

### ベクタ

ごくまれに二次元の座標を扱うことがありますが、simdフレームワークが使えず不便だったため、追加しました。

## ライセンス

CC0

