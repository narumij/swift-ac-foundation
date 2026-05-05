# swift-ac-foundation

English | [日本語](README.ja.md)

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## Usage

To use the `swift-ac-foundation` library in a SwiftPM project, add the following line to the `dependencies` section of your `Package.swift`:

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
  branch: "compatible/AtCoder/2025"),
```

Specifying by tag may cause the build to be rejected due to the use of `unsafeFlags` (as in C++).  
If necessary, please specify a revision directly.

Add `AcFoundation` to your executable target dependencies:

```swift
.target(name: "<target>", dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]),
```

Import it in your source code:

```swift
import AcFoundation
```

---

## Contents

### IOReader

#### Basic Usage

```swift
let N: Int = try read()
let (H, W): (Int, Int) = try read()
let (X, Y, Z): (Int, Int, Int) = try read()
let (A, B): (Int, String) = try read()
let (C, D): (Int, [Character]) = try read()
```

```swift
let A = try [Int].readLine()
let G = try [String].readLine()
let H = try [[Character]].readLine()
```

The `readLine()` methods are roughly equivalent to the following, but they do not create intermediate Swift strings:

```swift
let A = readLine()!.components(separatedBy: " ").map { Int($0)! }
let G = readLine()!.components(separatedBy: " ").map { $0 }
let H: [[Character]] = readLine()!.components(separatedBy: " ").map { $0.map { $0 } }
```

#### Details

Adds a `stdin` property and `read()` function to the following types, which read from standard input up to whitespace or newline:

- Fixed-width integers
- Floating-point numbers
- Strings
- `[Character]`
- `[UInt8]` (C-style character arrays)

**Input delimiters**  
Whitespace, tabs, and newlines are used as separators.

```swift
let N: Int = Int.stdin
let D: Double = Double.stdin
let S: String = String.stdin
let T: [Character] = [Character].stdin
let U: [UInt8] = [UInt8].stdin
```

**Example 1: Pair input**

```swift
let (H, W): (Int, Int) = try read()
```

```swift
let (H, W): (Int, Int) = stdin()
```

```swift
let (H, W): (Int, Int) = (try .read(), try .read())
```

```swift
let (H, W): (Int, Int) = (.stdin, .stdin)
```

**Example 2: Array input**

When reading a count `N` and a sequence `A`, you can write:

```swift
let N: Int = Int.stdin
let A: [Int] = (0..<N).map { .stdin }
```

This also supports both row-wise and column-wise data.

**Example 3: Query processing**

```swift
let Q: Int = Int.stdin
for _ in 0..<Q {
  switch Int.stdin {
    case 1:
      let (A, B) = (Int.stdin, Int.stdin)
      // process
    case 2:
      let C = Int.stdin
      // process
    default:
      break
  }
}
```

#### Additional helper methods

Reading with specified sizes:

```swift
let A = [Int].stdin(columns: N)
let G = [String].stdin(rows: H, columns: W)
let H = [[Character]].stdin(rows: H, columns: W)
let I = [[UInt8]].stdin(rows: H, columns: W)
```

#### Partial usage

If you only want to use IOReader, import:

```swift
import IOReader
```

#### `read` and `stdin`

The fundamental methods follow naming conventions using the verb `read`.

In contrast, convenience properties and methods that omit `try` use the identifier `stdin`.

One reason is that it is inspired by C++’s `cin`.

Another reason is that `stdin` is an unusual identifier, making name collisions unlikely.

Resolving `ambiguous` errors during a contest is quite difficult, so this choice helps avoid them.

Unusual identifiers are also easier to remember distinctly in this context.

#### Notes

This IOReader is designed to minimize:

- string splitting
- string copying
- numeric conversions

When handling large amounts of numeric input, it can be faster than standard `readLine()`.

On the other hand, when reading a very long string in a single line, `readLine()` is faster.

**Swift string operations are prone to TLE in AtCoder problems, so choose appropriately depending on the problem.**

---

### IOUtil

**Direct stdout/stderr output methods have been deprecated.**

Provides `TextOutputStream` implementations for standard output and standard error, usable via the `to:` parameter of `print`.

```swift
import Foundation
import IOUtil

print("Hello, world!", to: &FileOutputStream.standardError)
```

Also includes `fastPrint`, a specialized integer-only output method to reduce I/O overhead when benchmarking performance.

#### Partial usage

This module is only available via individual import:

```swift
import IOUtil
```

---

### Bisect

A port of Python’s `bisect`, enabling binary search in Swift.

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList.bisectLeft(99)) // 3
```

**Limiting the search range**  
You can limit the search range using `ArraySlice`:

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList[0..<3].bisectLeft(99)) // 3
```

#### Partial usage

```swift
import Bisect
```

---

### Pack

Since SE-0283 is frozen, tuples cannot be used as dictionary keys.

As a result, when solving problems such as ABC393C in Swift without excessive boilerplate, there is no direct equivalent to C++’s `pair`.

Therefore, you would normally need to define a struct and make it conform to `Hashable` each time.

To avoid requiring that level of protocol knowledge for casual competitive programming, this module is provided.

Using this, ABC393C can be solved in a compact way:

```swift
import AcFoundation

let (_, M): (Int, Int) = stdin()
nonisolated(unsafe) var m: [Pack<Int, Int>: Int] = [:]
nonisolated(unsafe) var ans = 0
for _ in 0 ..< M {
  var (u,v): (Int, Int) = stdin()
  if u == v {
    ans += 1
    continue
  }
  if u > v {
    swap(&u, &v)
  }
  m[.init(u, v), default: 0] += 1
}
m.forEach {
  ans += $0.value - 1
}
print(ans)
```

It also conforms to `Comparable`, so it can be used in algorithms such as Dijkstra.

If compilation issues occur, try `Pack2` or `Pack3` as alternatives.

#### Partial usage

```swift
import Pack
```

---

### CxxWrapped

Provides access to `std::gcd` and `std::lcm`.

These are not reimplemented — they actually call the real C++ implementations.

Originally intended to use C++ interop, but switched to calling via `extern "C"` using C interop.

```swift
import AcFoundation

print(gcd(12,16)) // 4
print(lcm(12,16)) // 48
```

#### Partial usage

```swift
import CxxWrapped
```

---

### CharacterUtil

In string problems, you must choose between Swift `String`, `[Character]`, or `[UInt8]`.

Each has trade-offs, but `[Character]` is recommended for contests.

However, working with character arrays can be inconvenient, especially for loops and lexicographical comparisons.

This module:

- Adds `Strideable` conformance to `Character` (ASCII only)

```swift
for c: Character in "a"..."z" {
  print(c)
}
```

- Adds lexicographical comparison operators for `[Character]`

```swift
print(Array("abc") < Array("abd")) // true
```

#### Partial usage

```swift
import CharacterUtil
```

---

### UInt8Util

Similar considerations apply when choosing between `String`, `[Character]`, and `[UInt8]`.

While `[Character]` is recommended, `[UInt8]` may be more convenient for those familiar with C/C++.

Since null-terminated C string APIs are being deprecated, `[UInt8]` is preferred over `CChar`.

This module allows:

```swift
let c: UInt8 = "A"
```

Also provides lexicographical comparison:

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)
print(abc < abd) // true
```

It also includes some equivalents of `Character` properties.

#### Partial usage

```swift
import UInt8Util
```

---

### StringUtil

For string problems, Swift’s `String` can be difficult for beginners because it does not support integer indexing.

This module provides convenient methods for easier usage.

**Note:** This is intended for beginners.

Swift strings are feature-rich and may cause TLE in competitive programming.

Use at your own discretion.

```swift
let s = "abcdef"

print(s[0])        // "a"
print(s[2..<4])    // "cd"
```

#### Partial usage

```swift
import StringUtil
```

---

### Miscellaneous

Uncategorized utilities.

```swift
import Miscellaneous
```

---

### Convinience

Shortcuts for convenience.

```swift
import Convinience
```

---

### MT19937

Mersenne Twister pseudo-random number generator.

Useful when reproducible randomness is required (e.g., AHC).

```swift
var mt = mt19937_64(seed: 0)
let randomInteger = Int.random(in: Int.min...Int.max, using: &mt)
let randomDouble = Double.random(in: 0...1, using: &mt)
```

#### Partial usage

```swift
import MT19937
```

---

## Other

To enable IOReader support for `modint` or `BigInt`, use:

```swift
extension static_modint: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

```swift
extension BigInt: IOStringConversionReadable {
  public static func convert(from: String) -> Self { .init(from)! }
}
```

Depending on constraints, you can gain some performance:

```swift
extension BigInt: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

```swift
extension static_modint: @retroactive IOUnsignedIntegerConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: UInt) -> Self { .init(rawValue: from) }
}
```

---

## License

This library is provided under CC0-1.0, but includes some Apache 2.0 licensed code.
