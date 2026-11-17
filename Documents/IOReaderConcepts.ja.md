# IOReader の考え方

[English](IOReaderConcepts.md) | 日本語

AcFoundationに含まれるIOReaderは、型を指定して標準入力から値を読み取る手段を提供します。
この文書は `main` の現行APIを対象とします。AtCoder 2025互換ブランチとは、行の検査や区切りの扱いが異なります。

## 行を読むか、値を読むか

入力が次の場合を考えます。

```text
3
1 2 3
```

Swift標準の `Swift.readLine()` は、`"3"`、`"1 2 3"` という行を返します。
数値として使うには、分割や変換が必要です。

IOReaderでは、次のように直接読み取れます。

```swift
let n = Int.stdin       // 3
let a = [Int].stdin(columns: n) // [1, 2, 3]
```

`Int.stdin` は先頭の空白を飛ばして整数を1つ読み、直後の改行は消費し、それ以外の区切りは残します。
続く読み取りも先頭の空白を飛ばすため、数値や単語を続けて読むときは、その区切りを意識する必要はありません。

例えば上の入力で `Int.stdin` を4回呼ぶと、順に `3`、`1`、`2`、`3` が得られます。
このとき、各呼び出し後の残りは `"1 2 3\n"`、`" 2 3\n"`、`" 3\n"`、`""` です。

## 行の形を指定する

- `[Int].stdin()` は、値が並ぶ1行を配列として読みます。
- `[Int].stdin(columns: n)` は、1行に並ぶ `n` 個の値を読みます。
- `[Int].stdin(rows: n)` は、1行に1値ずつ `n` 行読みます。
- `[[Int]].stdin(rows: h, columns: w)` は、各行に `w` 個の値が並ぶ `h` 行を読みます。

`columns` の途中で行が終わる場合や、指定個数の後に値が残る場合は停止します。
空白を含む行や空行をそのまま読みたい場合は、`String.readLine()` を使います。

## 値の読み取りから行の読み取りへ切り替える

単品の数値・単語の直後に読んだ改行は消費します。空白など、改行以外の区切りは残るので、続く行読みはそれも含めて読みます。

入力が `3\nhello world\n` の場合:

```swift
let n = Int.stdin             // 3
let text = String.readLine()   // "hello world"
```

入力が `3 hello world\n` なら、最初の `String.readLine()` は `" hello world"` を返します。
一方、`[Int].stdin(columns:)` などの行単位の読み取りは行末の区切りを消費します。

### Swift標準のreadLineや自作の入力処理と混ぜる場合

IOReaderの `String.readLine()` は、内部に押し戻された1文字も読み取ります。
`Swift.readLine()` やstdioを直接使う処理と混ぜる場合は、先に内部の押し戻しバッファを無効にします。
保留中の1文字は標準入力へ戻され、以後は標準の `ungetc` が使われます。

```swift
import AcFoundation
import IOBase

InputConfiguration.shared.usesPendingCharacter = false
let n = Int.stdin
let rest = Swift.readLine()
```

設定の退避・復元はできますが、読み取った入力を巻き戻す操作ではありません。
標準入力とその設定は共有なので、複数のタスクから同時に読み取らないでください。

## 文字の取り扱い

文字・文字列はASCII入力を想定しています。

| 分類 | 型の例 |
|---|---|
| 数値 | `Int`, `UInt`, `Double`, `Float` |
| 単語 | `String`, `[Character]`, `[UInt8]` |
| 1文字 | `Character`, `UInt8` |

`Character.stdin` と `UInt8.stdin` は、先頭の空白を飛ばして1文字だけ読みます。
例えば `ABC` から `Character.stdin` を3回呼ぶと、`A`、`B`、`C` を順に取得できます。
`UInt8` は数値型ですが、IOReaderでは文字データとして扱うため、数値入力には `Int` 等を使います。

次のページ: [IOReader の入力例](IOReaderRecipes.ja.md)
