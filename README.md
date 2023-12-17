# swift-ac-foundation

## 目的

競技プログラミング以外では滅多に出会わない課題について、解決済みとすること。

## 内容

### 入力

#### Reader

以下の型に、標準入力から空白または改行までを取り出すread()メソッドを付与します。

- 固定長整数
- バイナリ浮動小数
- 文字列
- C文字配列

```
let N: Int = Int.read()
```

getchar_unlocked()を用いた読み込みとなっていて、必要最小限しか読みません。
文字の整数化にはatolを用いています。Intのパーサーに渡す文字列を構築する必要がなくなり、この分の実行時間も軽減されています。

#### ReaderHelper

タプルや配列の入力を補助します。

```
let N,M: Int
(N,M) = Input.read()
```

```
let N: Int
let A: [Int]
N = Input.read()
A = Input.read(columns: N)
```
