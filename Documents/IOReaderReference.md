# IOReader Reference

English | [日本語](IOReaderReference.ja.md)

This document describes the current API on `main`. Line validation and separator handling differ from the AtCoder 2025 compatibility branch.

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

Numbers and strings read the next token. `Character` and `UInt8` skip leading whitespace and read one character.
Successive calls to `Character.stdin` read `A`, `B`, and `C` from `ABC`.

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
| Signed integers | `Int`, `Int16`, `Int32`, `Int64`, `Int128` |
| Unsigned integers | `UInt`, `UInt16`, `UInt32`, `UInt64`, `UInt128` |
| Floating-point | `Float`, `Double` |
| Strings | `String`, `[Character]`, `[UInt8]` |
| One character | `Character`, `UInt8` |

`Int128` and `UInt128` are available on macOS 15.0 or later. Corresponding type aliases such as `CInt` and `CLongLong` also work.

`UInt8.stdin` reads one ASCII character, not a number.
Use `Int.stdin` or another integer type when you want to read numeric `8` as an integer.

## Reading a Fixed Number of Numeric Values

```swift
static func stdin(columns: Int) -> [Element]
static func stdin(rows: Int) -> [Element]
```

`columns` is the number of values on one line; `rows` reads one value per line.
A `columns` read stops the program if the line ends too early or contains extra values.
A `rows` read checks that each value is immediately followed by a newline or EOF.

```swift
let a: [Int] = .stdin(columns: 3)
let b: [Double] = .stdin(rows: 3)
```

Supported element types are:

| Category | Element types |
|---|---|
| Signed integers | `Int`, `Int16`, `Int32`, `Int64`, `Int128` |
| Unsigned integers | `UInt`, `UInt16`, `UInt32`, `UInt64`, `UInt128` |
| Floating-point | `Float`, `Double` |

## Reading a Fixed-Size 2D Array

```swift
static func stdin(rows: Int, columns: Int) -> [[Element]]
```

Reads `rows` lines containing `columns` values each and returns them as `[[Element]]`.

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
It reads only the requested number of characters, leaving the following character or separator unread.
For input `abcde`, successive calls to `String.stdin(columns: 3)` and `String.stdin(columns: 2)` return `"abc"` and `"de"`.

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

`rows:` reads whole lines, preserving spaces and empty lines. `rows:columns:` is intended for fixed-width grids without spaces inside each row.

## Reading Tokens Until the End of a Line

```swift
static func stdin() -> [Element]
```

Reads whitespace-separated tokens until the end of the line or EOF.
It skips trailing spaces and stops at a newline or EOF.
Use the whole-line APIs below when empty lines must be preserved.

```swift
let a: [Int] = .stdin()
let words: [String] = .stdin()
```

Supported element types are:

| Category | Element types |
|---|---|
| Signed integers | `Int`, `Int16`, `Int32`, `Int64`, `Int128` |
| Unsigned integers | `UInt`, `UInt16`, `UInt32`, `UInt64`, `UInt128` |
| Floating-point | `Float`, `Double` |
| Strings | `String`, `[Character]`, `[UInt8]` |

## Reading a Whole Line Including Spaces

`String.readLine()`, `[Character].readLine()`, and `[UInt8].readLine()` read a whole line, preserving spaces and removing the trailing newline.
An empty line produces an empty value. The return value is not optional; EOF with no line to read stops the program.
These APIs have no `strippingNewline` parameter.

```swift
let line = String.readLine()
let lineChars = [Character].readLine()
let lineBytes = [UInt8].readLine()
```

## Reading Tuples

```swift
func stdin<each T: Component>() -> (repeat each T)
```

Reads a tuple of `Component` types from the same line. The program stops if the line ends before the tuple is complete.

```swift
let (n, m): (Int, Int) = stdin()
let (s, x): (String, Double) = stdin()
```

## Fixed-Size Groups in IOReader

`SIMD2`, `SIMD3`, and `SIMD4` read their values from one line when the scalar type conforms to `Component`.
`InlineArray` is also part of IOReader itself. It is available on macOS 26.0 or later when its element type conforms to `Component`. Its element count must match the number of values on the line.

```swift
let pair = SIMD2<Int>.stdin
let triple: InlineArray<3, Int> = .stdin
```

## Types Added by IOReaderExtra

Importing `IOReaderExtra` enables `stdin` for the following types.

| Type | Condition |
|---|---|
| `Pack2`, `Pack3`, `Pack4` | Each contained type conforms to `Component` |
| `Pack` | macOS 14.0 or later; each contained type conforms to `Component` |

Example:

```swift
import IOReaderExtra
import Pack

let a: Pack2<Int, String> = .stdin
```

## Advanced: Supporting Custom Types

To make your own type readable from input, conform it to `IOConversion` and implement `read()`.
For ordinary use, the concrete types listed above are enough.

`read()` is not meant to be called directly. It is the implementation that enables `stdin`.
Inside `read()`, read the values with `readTuple()` and build your type from them.

```swift
import AcFoundation

struct Edge {
  let u: Int
  let v: Int
  let w: Int
}

extension Edge: IOConversion, Group {
  static func read() throws -> (value: Edge, separator: UInt8?) {
    try readTuple { (value: (Int, Int, Int)) in
      Edge(u: value.0, v: value.1, w: value.2)
    }
  }
}

let edge = Edge.stdin
let edges = [Edge].stdin(rows: 3)
```

`read()` and `readTuple()` return `(value: ..., separator: UInt8?)`. The closure converts only the value; `readTuple` passes the separator through to the line iterator. `nil` represents EOF.

`readTuple()` reads all values from the same line. If the line ends before all values are read, the program stops.
Adding `Group` enables `stdin` and `stdin(rows:)`, with one value of the type per line.

`readTuple()` also reads a single value.
For a type read from one token, conform to `IOReader.Numeric` instead of `Group`. This enables `stdin` and `stdin(columns:)`.
Write `IOReader.Numeric` with the module name, because `Swift.Numeric` has the same name.

When a type can be created from several input types, `as` chooses which type to read.

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

extension Label: IOConversion, IOReader.Numeric {
  static func read() throws -> (value: Label, separator: UInt8?) {
    try readTuple { (value: Int) in Label(value) }
  }
}

let label = Label.stdin
```

## Failure Behavior

The `stdin` APIs assume that input follows the constraints of a competitive programming problem.
They trap at runtime when input is missing or when whitespace appears inside a fixed-length string.
