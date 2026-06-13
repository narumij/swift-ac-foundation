# Swift Input For Serious Competitor

(実践向けは[こちら](SwiftInputForCompetitor.md)をどうぞ。)

ここでは、IOReader が提供している入力 API を、実際に使う具体型ベースで整理します。

## 入力の区切り

IOReader は標準入力を空白区切りの token として読みます。
半角スペース、改行、タブなどで区切られた値を順に取得できます。

文字列や文字は ASCII 入力を想定しています。

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

## 数値配列を固定個数読む

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

## 固定長 ASCII 列を読む

`String`, `[Character]`, `[UInt8]` は、固定長の ASCII 文字列を読む API を持ちます。

```swift
static func stdin(columns: Int) -> Self
```

`columns` で指定した ASCII 文字数を読みます。
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

`String` の配列では、戻り値は `[String]` です。

```swift
static func stdin(rows: Int) -> [String]
static func stdin(rows: Int, columns: Int) -> [String]
```

```swift
let s: [String] = .stdin(rows: h)
let fixed: [String] = .stdin(rows: h, columns: w)
```

`[Character]` と `[UInt8]` の配列では、戻り値は 2 次元配列です。

```swift
static func stdin(rows: Int) -> [[Character]]
static func stdin(rows: Int, columns: Int) -> [[Character]]

static func stdin(rows: Int) -> [[UInt8]]
static func stdin(rows: Int, columns: Int) -> [[UInt8]]
```

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

`[Character].readLine()` と `[UInt8].readLine()` は Swift 標準の `readLine()` に近い、行全体を読む API です。
空白を含む行をそのまま読み、`strippingNewline` が `true` のときは末尾の改行を取り除きます。

```swift
let lineChars = [Character].readLine()
let lineBytes = [UInt8].readLine()

let rawChars = [Character].readLine(strippingNewline: false)
let rawBytes = [UInt8].readLine(strippingNewline: false)
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

## 発展: 独自型対応

独自型を入力対応にしたい場合は、`SingleReadable` に準拠して読み方を実装します。
通常の利用では、上で挙げた具体型を使えば十分です。

ここでの `read()` は直接呼ぶためではなく、`stdin` を使えるようにするための実装です。
たとえば、鞄の番号や荷物の重さを、そのまま `Int` として扱わず別の型にできます。

```swift
import AcFoundation

struct Bag {
  let number: Int
}

extension Bag: SingleReadable {
  static func read() throws -> Bag {
    Bag(number: try Int.read())
  }
}

struct Luggage {
  let weight: Int
}

extension Luggage: SingleReadable {
  static func read() throws -> Luggage {
    Luggage(weight: try Int.read())
  }
}

let bag = Bag.stdin
let luggage = Luggage.stdin
```

複数の入力対応型を組み合わせる型も作れます。
先ほどの `Bag` と `Luggage` の定義に続けて、次のように書けます。

```swift
struct BagAndLuggage {
  let bag: Bag
  let luggage: Luggage
}

extension BagAndLuggage: SingleReadable {
  static func read() throws -> BagAndLuggage {
    BagAndLuggage(
      bag: try Bag.read(),
      luggage: try Luggage.read()
    )
  }
}

let pair = BagAndLuggage.stdin

let bag = pair.bag
let luggage = pair.luggage
```

`IOIntegerConversionReadable` などは、複数の型から作れる独自型に対して、どの入力型を経由して読むかを決めるための補助プロトコルです。
initializer の候補が曖昧になる場合でも、`convert(from:)` の引数型で入力経路を明示できます。
| プロトコル | 変換元 |
|---|---|
| `IOIntegerConversionReadable` | `Int` |
| `IOUnsignedIntegerConversionReadable` | `UInt` |
| `IODoubleConversionReadable` | `Double` |
| `IOStringConversionReadable` | `String` |
| `IOBytesConversionReadable` | `[UInt8]` |

たとえば、数字と文字列の両方から作れる型では、入力を整数として読むことを明示できます。
```swift
import AcFoundation

struct Label {
  let value: String

  init(_ value: Int) {
    self.value = String(value)
  }

  init(_ value: String) {
    self.value = value
  }
}

extension Label: IOIntegerConversionReadable {
  static func convert(from value: Int) -> Label {
    Label(value)
  }
}

let label = Label.stdin
```

## 失敗時の扱い

`stdin` 系は、競技プログラミングの制約どおりに入力が与えられる前提で使う API です。
入力が足りない場合や、固定長文字列の途中に空白が入る場合などは実行時エラーになります。
