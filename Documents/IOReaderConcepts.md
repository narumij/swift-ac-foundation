# IOReader Concepts

English | [日本語](IOReaderConcepts.ja.md)

IOReader, included in AcFoundation, reads values from standard input using their types.
This document describes the current API on `main`. Line validation and separator handling differ from the AtCoder 2025 compatibility branch.

## Reading Lines or Values

Consider this input:

```text
3
1 2 3
```

Swift's standard `Swift.readLine()` returns the lines `"3"` and `"1 2 3"`.
Using them as numbers requires splitting or conversion.

IOReader reads the values directly:

```swift
let n = Int.stdin       // 3
let a = [Int].stdin(columns: n) // [1, 2, 3]
```

`Int.stdin` skips leading whitespace, reads one integer, and consumes an immediately following newline. Other trailing bytes remain unread.
The next value read also skips leading whitespace, so successive number or word reads do not need to handle the separator explicitly.

Calling `Int.stdin` four times on the input above returns `3`, `1`, `2`, and `3`.
After each call, the remaining input is `"1 2 3\n"`, `" 2 3\n"`, `" 3\n"`, and `""`, respectively.

## Specifying the Shape of a Line

- `[Int].stdin()` reads a line of values into an array.
- `[Int].stdin(columns: n)` reads `n` values on one line.
- `[Int].stdin(rows: n)` reads `n` lines with one value per line.
- `[[Int]].stdin(rows: h, columns: w)` reads `h` lines with `w` values per line.

A `columns` read stops the program if the line ends too early or contains extra values.
Use `String.readLine()` to preserve spaces and empty lines.

## Switching from Values to Lines

A single number or word read consumes an immediately following newline. Both bytes of CRLF are consumed as one newline. Other separators remain unread and are included in the following whole-line read.

For input `3\nhello world\n`:

```swift
let n = Int.stdin             // 3
let text = String.readLine()   // "hello world"
```

For input `3 hello world\n`, the first `String.readLine()` returns `" hello world"` instead.
Line-based reads such as `[Int].stdin(columns:)` consume the separator at the end of the line.

### Mixing with Swift.readLine or Other Input Helpers

IOReader's `String.readLine()` also reads a character held in the internal pushback buffer.
Before mixing IOReader with `Swift.readLine()` or direct stdio reads, disable the internal pushback buffer.
Any pending character is restored to standard input, and subsequent pushback uses standard `ungetc`.

```swift
import AcFoundation
import IOBase

InputConfiguration.shared.usesPendingCharacter = false
let n = Int.stdin
let rest = Swift.readLine()
```

Saving and restoring the configuration does not rewind consumed input.
Standard input and its configuration are shared; do not read from multiple tasks concurrently.

## Characters

Character and string input assumes ASCII.

| Category | Example types |
|---|---|
| Numbers | `Int`, `UInt`, `Double`, `Float` |
| Words | `String`, `[Character]`, `[UInt8]` |
| One character | `Character`, `UInt8` |

`Character.stdin` and `UInt8.stdin` skip leading whitespace and read exactly one character.
For example, three calls to `Character.stdin` read `A`, `B`, and `C` from `ABC`.
Although `UInt8` is a numeric type, IOReader treats it as character data. Use `Int` or another supported numeric type for numbers.

Next page: [IOReader Recipes](IOReaderRecipes.md)
