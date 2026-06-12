# Swift Input For Serious Competitor

(実践向けは[こちら](SwiftInputForCompetitor.md)をどうぞ。)

ここでは、IOReader が提供している入力 API を、実装上のプロトコルではなく実際に使う具体型ベースで整理します。

## 基本方針

IOReader は標準入力を空白区切りの token として読みます。
空白として扱う文字は `HT`, `LF`, `CR`, `SP` です。

競技中は、型に生えた `stdin` プロパティや `stdin(...)` メソッドで入力を読みます。

## 1 token を読む

```swift
static var stdin: Self { get }
```

入力から次の token を 1 つ読み、指定した型として返します。

```swift
let n = Int.stdin
let x = Double.stdin
let s = String.stdin
let c = Character.stdin
let b = UInt8.stdin
```

### 対応型

| 分類 | 型 |
|---|---|
| 符号付き整数 | `Int`, `CInt`, `CLongLong` |
| 符号なし整数 | `UInt`, `CUnsignedInt`, `CUnsignedLongLong` |
| 浮動小数 | `Double` |
| 文字列 | `String`, `[Character]`, `[UInt8]` |
| 1 文字 | `Character`, `UInt8` |

`UInt8.stdin` は数値ではなく ASCII 文字 1 文字として読みます。
数値の `8` を整数として読みたい場合は、`Int.stdin` などを使ってください。

`Character` と `[Character]` は ASCII 入力を想定しています。

## 固定個数の配列を読む

```swift
static func stdin(columns: Int) -> [Element]
static func stdin(rows: Int) -> [Element]
```

数値系の配列では、`columns` と `rows` はどちらも「読む個数」です。
入力上の改行位置は見ません。

```swift
let a: [Int] = .stdin(columns: 3)
let b: [Double] = .stdin(rows: 3)
```

対応する要素型は以下です。

| 分類 | 要素型 |
|---|---|
| 符号付き整数 | `Int`, `CInt`, `CLongLong` |
| 符号なし整数 | `UInt`, `CUnsignedInt`, `CUnsignedLongLong` |
| 浮動小数 | `Double` |

## 固定サイズの 2 次元配列を読む

```swift
static func stdin(rows: Int, columns: Int) -> [[Element]]
```

`rows * columns` 個の token を読み、`[[Element]]` で返します。

```swift
let grid: [[Int]] = .stdin(rows: 2, columns: 3)
```

対応する要素型は、固定個数の数値配列と同じです。

## ASCII 文字列を読む

`String`, `[Character]`, `[UInt8]` は ASCII 文字列向けの追加 API を持ちます。

```swift
static func stdin(columns: Int) -> Self
```

`columns` で指定した文字数を読みます。
途中に空白や改行があると失敗します。
読み終わった直後の 1 文字は区切りとして消費されます。

```swift
let s = String.stdin(columns: 5)
let chars: [Character] = .stdin(columns: 5)
let bytes: [UInt8] = .stdin(columns: 5)
```

`String.stdin` や `[UInt8].stdin` は空白までを読む token 入力です。
一方、`stdin(columns:)` は空白を含まない固定長入力です。

## ASCII 文字列の配列を読む

```swift
static func stdin(rows: Int) -> [String]
static func stdin(rows: Int, columns: Int) -> [String]
```

`String` では、`rows` 個の token または固定長文字列を読み、`[String]` で返します。

```swift
let s: [String] = .stdin(rows: h)
let fixed: [String] = .stdin(rows: h, columns: w)
```

`[Character]` と `[UInt8]` の配列では、結果は 2 次元配列になります。

```swift
let chars: [[Character]] = .stdin(rows: h)
let bytes: [[UInt8]] = .stdin(rows: h, columns: w)
```

| 呼び出し | 戻り値 |
|---|---|
| `[String].stdin(rows:)` | `[String]` |
| `[String].stdin(rows:columns:)` | `[String]` |
| `[[Character]].stdin(rows:)` | `[[Character]]` |
| `[[Character]].stdin(rows:columns:)` | `[[Character]]` |
| `[[UInt8]].stdin(rows:)` | `[[UInt8]]` |
| `[[UInt8]].stdin(rows:columns:)` | `[[UInt8]]` |

## 行末まで token を読む

```swift
static func stdin() -> [Element]
```

行末または EOF まで、空白区切りの token を読みます。
区切りが改行に到達したところで停止します。

```swift
let a: [Int] = .stdin()
let words: [String] = .stdin()
```

対応する要素型は以下です。

| 分類 | 要素型 |
|---|---|
| 符号付き整数 | `Int`, `CInt`, `CLongLong` |
| 符号なし整数 | `UInt`, `CUnsignedInt`, `CUnsignedLongLong` |
| 浮動小数 | `Double` |
| 文字列 | `String`, `[Character]`, `[UInt8]` |

## 空白を含む 1 行を読む

```swift
static func readLine(strippingNewline: Bool = true) -> [Character]?
static func readLine(strippingNewline: Bool = true) -> [UInt8]?
```

`[Character].readLine()` と `[UInt8].readLine()` は Swift 標準の `readLine()` に近い、行全体を読む API です。
空白を含む行をそのまま読み、`strippingNewline` が `true` のときは末尾の `LF` と、その直前の `CR` を取り除きます。

```swift
let lineChars = [Character].readLine()
let lineBytes = [UInt8].readLine()
```

## タプルを読む

```swift
func stdin<each T>() -> (repeat each T)
```

`stdin` 対応型のタプルを一括で読みます。

```swift
let (n, m): (Int, Int) = stdin()
let (s, x): (String, Double) = stdin()
```

## IOReaderExtra で増える型

`IOReaderExtra` を import すると、以下の型でも `stdin` が使えます。

| 型 | 条件 |
|---|---|
| `BigInt` | `IOReaderExtra` と `BigInt` を利用する |
| `Int128`, `UInt128` | macOS 15.0 以降 |
| `static_modint`, `dynamic_modint` | AtCoder の modint |
| `Pack`, `Pack2`, `Pack3` | 中身の型が `stdin` 対応型 |
| `InlineArray` | macOS 26.0 以降、要素型が `stdin` 対応型 |

例:

```swift
import IOReaderExtra

let x = BigInt.stdin
let a: Pack2<Int, String> = .stdin
```

## 変換プロトコル

独自型を入力対応にしたい場合は、変換元に応じて以下のプロトコルを使えます。

| プロトコル | 変換元 | 付与される主な API |
|---|---|---|
| `IOIntegerConversionReadable` | `Int` | `stdin`, 配列入力, 行 token 入力 |
| `IOUnsignedIntegerConversionReadable` | `UInt` | `stdin`, 配列入力, 行 token 入力 |
| `IODoubleConversionReadable` | `Double` | `stdin`, 配列入力, 行 token 入力 |
| `IOStringConversionReadable` | `String` | `stdin`, 配列入力, 行 token 入力 |
| `IOBytesConversionReadable` | `[UInt8]` | `stdin`, 配列入力, 行 token 入力 |

```swift
struct Point {
  let rawValue: Int
}

extension Point: IOIntegerConversionReadable {
  static func convert(from value: Int) -> Point {
    Point(rawValue: value)
  }
}

let p = Point.stdin
```

## 失敗時の扱い

`stdin` 系は内部で入力失敗を強制 unwrap します。
競技プログラミングの制約どおりに入力が与えられる前提で使う API です。

主な失敗要因は以下です。

| 状況 | 例 |
|---|---|
| 値を読み始める前に EOF に到達した | 入力が足りない |
| 固定長文字列の途中に EOF に到達した | `String.stdin(columns: 5)` に 4 文字しかない |
| 固定長文字列の途中に空白や改行があった | `String.stdin(columns: 5)` に `ab cd` が来た |
| 文字列や変換処理に失敗した | ASCII 文字列化や独自型変換に失敗した |
