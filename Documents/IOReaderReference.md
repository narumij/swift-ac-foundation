# IOReader Reference

English | [日本語](IOReaderReference.ja.md)

(For input examples, see [IOReader Recipes](IOReaderRecipes.md).)

This page organizes the input APIs provided by IOReader around the concrete types you use in practice.

## Input Separators

IOReader reads standard input as whitespace-separated tokens.
Values separated by spaces, newlines, tabs, and similar whitespace are read in order.

Strings and characters assume ASCII input.

During a contest, read input through the `stdin` property or `stdin(...)` methods on supported types.

## Reading One Token

```swift
static var stdin: Self { get }
```

Reads the next token from input and returns it as the specified type.

```swift
let n = Int.stdin
let x = Double.stdin
let s = String.stdin
let c = Character.stdin
let b = UInt8.stdin
```

### Supported Types

| Category | Types |
|---|---|
| Signed integers | `Int`, `CInt`, `CLongLong` |
| Unsigned integers | `UInt`, `CUnsignedInt`, `CUnsignedLongLong` |
| Floating-point | `Double` |
| Strings | `String`, `[Character]`, `[UInt8]` |
| One character | `Character`, `UInt8` |

`UInt8.stdin` reads one ASCII character, not a number.
Use `Int.stdin` or another integer type when you want to read numeric `8` as an integer.

## Reading a Fixed Number of Numeric Values

```swift
static func stdin(columns: Int) -> [Element]
static func stdin(rows: Int) -> [Element]
```

For numeric arrays, both `columns` and `rows` mean the number of values to read.
They do not inspect line breaks in the input.

```swift
let a: [Int] = .stdin(columns: 3)
let b: [Double] = .stdin(rows: 3)
```

Supported element types are:

| Category | Element types |
|---|---|
| Signed integers | `Int`, `CInt`, `CLongLong` |
| Unsigned integers | `UInt`, `CUnsignedInt`, `CUnsignedLongLong` |
| Floating-point | `Double` |

## Reading a Fixed-Size 2D Array

```swift
static func stdin(rows: Int, columns: Int) -> [[Element]]
```

Reads `rows * columns` tokens and returns them as `[[Element]]`.

```swift
let grid: [[Int]] = .stdin(rows: 2, columns: 3)
```

The supported element types are the same as fixed-count numeric arrays.

## Reading a Fixed-Length ASCII Sequence

`String`, `[Character]`, and `[UInt8]` provide APIs for reading fixed-length ASCII strings.

```swift
static func stdin(columns: Int) -> Self
```

Reads the specified number of ASCII characters.
It fails if whitespace or a newline appears before that length is reached.
The character immediately after the fixed-length value is consumed as a separator.

```swift
let s = String.stdin(columns: 5)
let chars: [Character] = .stdin(columns: 5)
let bytes: [UInt8] = .stdin(columns: 5)
```

`String.stdin` and `[UInt8].stdin` are token inputs that read up to whitespace.
`stdin(columns:)` is fixed-length input without whitespace inside the value.

## Reading Arrays of ASCII Strings

For arrays of `String`, the return type is `[String]`.

```swift
static func stdin(rows: Int) -> [String]
static func stdin(rows: Int, columns: Int) -> [String]
```

```swift
let s: [String] = .stdin(rows: h)
let fixed: [String] = .stdin(rows: h, columns: w)
```

For arrays of `[Character]` and `[UInt8]`, the return type is a 2D array.

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

| Call | Return type |
|---|---|
| `[String].stdin(rows:)` | `[String]` |
| `[String].stdin(rows:columns:)` | `[String]` |
| `[[Character]].stdin(rows:)` | `[[Character]]` |
| `[[Character]].stdin(rows:columns:)` | `[[Character]]` |
| `[[UInt8]].stdin(rows:)` | `[[UInt8]]` |
| `[[UInt8]].stdin(rows:columns:)` | `[[UInt8]]` |

## Reading Tokens Until the End of a Line

```swift
static func stdin() -> [Element]
```

Reads whitespace-separated tokens until the end of the line or EOF.
It stops when the separator reaches a newline.

```swift
let a: [Int] = .stdin()
let words: [String] = .stdin()
```

Supported element types are:

| Category | Element types |
|---|---|
| Signed integers | `Int`, `CInt`, `CLongLong` |
| Unsigned integers | `UInt`, `CUnsignedInt`, `CUnsignedLongLong` |
| Floating-point | `Double` |
| Strings | `String`, `[Character]`, `[UInt8]` |

## Reading a Whole Line Including Spaces

`[Character].readLine()` and `[UInt8].readLine()` are APIs similar to Swift's standard `readLine()` and read a whole line.
They preserve spaces, and remove the trailing newline when `strippingNewline` is `true`.

```swift
let lineChars = [Character].readLine()
let lineBytes = [UInt8].readLine()

let rawChars = [Character].readLine(strippingNewline: false)
let rawBytes = [UInt8].readLine(strippingNewline: false)
```

## Reading Tuples

```swift
func stdin<each T>() -> (repeat each T)
```

Reads a tuple whose element types support `stdin`.

```swift
let (n, m): (Int, Int) = stdin()
let (s, x): (String, Double) = stdin()
```

## Types Added by IOReaderExtra

Importing `IOReaderExtra` enables `stdin` for the following types.

| Type | Condition |
|---|---|
| `BigInt` | Use `IOReaderExtra` and `BigInt` |
| `Int128`, `UInt128` | macOS 15.0 or later |
| `static_modint`, `dynamic_modint` | AtCoder modint |
| `Pack`, `Pack2`, `Pack3` | The contained types support `stdin` |
| `InlineArray` | macOS 26.0 or later, and the element type supports `stdin` |

Example:

```swift
import IOReaderExtra

let x = BigInt.stdin
let a: Pack2<Int, String> = .stdin
```

## Advanced: Supporting Custom Types

To make your own type readable from input, conform it to `SingleReadable` and implement how it should be read.
For ordinary use, the concrete types listed above are enough.

The `read()` here is not meant to be called directly. It is the implementation that enables `stdin`.
For example, you can represent a bag number or luggage weight as its own type instead of using plain `Int` everywhere.

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

You can also build a type by combining multiple input-readable types.
Continuing from the `Bag` and `Luggage` definitions above:

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

`IOIntegerConversionReadable` and related protocols are helper protocols for custom types that can be created from multiple source types. They decide which input type should be used.
Even when initializer candidates are ambiguous, the argument type of `convert(from:)` makes the input path explicit.

| Protocol | Source type |
|---|---|
| `IOIntegerConversionReadable` | `Int` |
| `IOUnsignedIntegerConversionReadable` | `UInt` |
| `IODoubleConversionReadable` | `Double` |
| `IOStringConversionReadable` | `String` |
| `IOBytesConversionReadable` | `[UInt8]` |

For example, when a type can be created from both a number and a string, you can explicitly read input as an integer.

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

## Failure Behavior

The `stdin` APIs assume that input follows the constraints of a competitive programming problem.
They trap at runtime when input is missing or when whitespace appears inside a fixed-length string.
