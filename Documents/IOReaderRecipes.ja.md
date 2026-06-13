# IOReader の入力例

[English](IOReaderRecipes.md) | 日本語

(IOReader の考え方は[こちら](IOReaderConcepts.ja.md)をどうぞ。)

ここでは、IOReaderを用いた実践的な入力方法について説明します。

## 文字列の取得

入力が以下の場合

```
Apple
```

以下で取れます

```swift
let S = String.stdin // -> "Apple"
```

万が一空白区切りで複数単語あった場合

```
Apple Banana
```

以下で取れます

```swift
let S = String.stdin // -> "Apple"
let T = String.stdin // -> "Banana"
```

幅と高さが指定されて文字列の配列だった場合

```
4 4
####
#..#
#..#
####
```

以下で取れます

```swift
let H = Int.stdin // -> 4
let W = Int.stdin // -> 4
let S = [String].stdin(rows: H, columns: W)
// -> [
//   "####",
//   "#..#",
//   "#..#",
//   "####"
// ]
```

## 数列の取得

長さ指定付き配列の場合、

```
4
5 6 7 8
```

以下で取れます

```swift
let N = Int.stdin // -> 4
let A = [Int].stdin(columns: N)
// -> [5, 6, 7, 8]
```

サイズ指定付きの2次元配列の場合

```
3 3
1 2 3
4 5 6
7 8 9
```

以下で取れます

```swift
let N = Int.stdin // -> 3
let M = Int.stdin // -> 3
let A = [[Int]].stdin(rows: N, columns: M)
// -> [
//   [1, 2, 3],
//   [4, 5, 6],
//   [7, 8, 9],
// ]
```

## タプル

複数項目を取得する際、

```
4 8
```

以下のように書くこともできます。

```swift
let (N, M): (Int, Int) = stdin()
// N -> 4
// M -> 8
```

## まとめ

型に生えた `stdin` メソッドや `stdin()` 関数を用いることで、
配列、二次元配列、タプルを簡潔に取得できます。

次のページ: [IOReader リファレンス](IOReaderReference.ja.md)
