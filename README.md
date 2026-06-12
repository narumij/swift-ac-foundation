# swift-ac-foundation

English | [日本語](README.ja.md)

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## Usage

To use the swift-ac-foundation library in a SwiftPM project, add the following entry to `dependencies` in your `Package.swift` file.

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
   branch: "compatible/AtCoder/2025"),
```

Specifying a tag can cause the build to be rejected because this package uses C++ `unsafeFlags`. If necessary, specify a revision directly.

Add `AcFoundation` to the dependencies of your executable target.

```swift
.target(name: "<target>", dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]),
```

Import it in your source code.

```swift
import AcFoundation
```

---

## Contents

### IOReader

#### Quick Start

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

The `readLine()` methods are roughly equivalent to the following code, but they do not create intermediate Swift strings.

```swift
let A = readLine()!.components(separatedBy: " ").map { Int($0)! }
let G = readLine()!.components(separatedBy: " ").map { $0 }
let H: [[Character]] = readLine()!.components(separatedBy: " ").map { $0.map{ $0 } }
```

#### Details

For the following types, this package adds a `stdin` property and `read()` member functions that read from standard input up to a space or newline.

- Fixed-width integers
- Floating-point numbers
- Strings
- Character arrays (`Character`)
- C-style character arrays (`UInt8`)

**Input Separators**  
Spaces, tabs, and newlines are used as separators.

```swift
let N: Int = Int.stdin
let D: Double = Double.stdin
let S: String = String.stdin
let T: [Character] = [Character].stdin
let U: [UInt8] = [UInt8].stdin
```

**Example 1: Pair Input**  
For example, if the input is arranged as `H W`, you can write it as follows.

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

**Example 2: Array Input**  
When reading a count `N` and a sequence `A`, write the following. This can also handle data arranged vertically or horizontally.

```swift
let N: Int = Int.stdin
let A: [Int] = (0..<N).map { .stdin }
```

**Example 3: Processing Queries**  
This example reads `Q` queries and processes input depending on each query type.

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

#### Other Convenient Member Functions

When reading a specified number of values:

```swift
let A = [Int].stdin(columns: N)
let G = [String].stdin(rows: H, columns: W)
let H = [[Character]].stdin(rows: H, columns: W)
let I = [[UInt8]].stdin(rows: H, columns: W)
```

#### Partial Import

If you only want to use IOReader features, import the following module.

```swift
import IOReader
```

#### `read` and `stdin`

The underlying methods and functions follow naming conventions and include the verb `read` in their identifiers.

In contrast, convenience properties and methods that can omit `try` use the identifier `stdin`.

One reason is that this is inspired by C++ `cin`.

Another reason is the calculation that very few people would use the identifier `stdin` in such an unusual way.

Resolving `ambiguous` errors during a contest is quite difficult, so this library tries to avoid them as much as possible.

Unusual identifiers are also easy to forget, and in that sense `stdin` seemed like the best available choice.

#### Notes

This IOReader is designed to minimize wasted string splitting, string copying, and numeric conversion.  
When many numbers are provided, it may run faster than using the standard `readLine()`.

On the other hand, when reading a very long string as a whole line, `readLine()` is faster.  
**Swift string operations can easily cause TLE depending on the AtCoder problem, so choose the appropriate approach for each problem.**

---

### IOUtil

**The stdout/stderr-based approach has been discontinued.**

This module provides `TextOutputStream` values for standard output and standard error that can be used with the `to:` parameter of the `print` function.
This allows output to standard error as shown below.

```swift
import Foundation
import IOUtil

print("Hello, world!", to: &FileOutputStream.standardError)
```

It also adds `fastPrint`, an integer-only output helper intended to reduce I/O overhead when comparing performance.

#### Partial Import

This module is provided only through an individual import.

If you want to use IOUtil features, import the following module.

```swift
import IOUtil
```

---

### Bisect

This is a port of Python's `bisect`, enabling binary search in Swift.

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList.bisectLeft(99)) // 3
```

**Limiting the Search Range**  
You can limit the search range by using `ArraySlice`.

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList[0..<3].bisectLeft(99)) // 3
```

#### Partial Import

If you only want to use Bisect features, import the following module.

```swift
import Bisect
```

---

### Pack

Because SE-283 is frozen, tuples still cannot be used as dictionary keys.
For example, when trying to solve graph problems such as ABC393C in Swift without boilerplate, there is no equivalent of C++ `Pair`, so you have to write a struct and apply `Hashable` to it each time.
This library provides `Pack` because requiring that much protocol knowledge from people who casually enjoy competitive programming felt excessive.

With this, ABC393C can be accepted with a compact submission like the following, in principle.

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

It also conforms to `Comparable`, so it can be used when writing Dijkstra's algorithm.

If compilation becomes a problem, try the fallback types `Pack2` or `Pack3`.

#### Partial Import

If you only want to use Pack features, import the following module.

```swift
import Pack
```
---

### CxxWrapped

This module provides `std::gcd` and `std::lcm`.

They are not merely things that behave like `std::gcd`; they actually call `std::gcd`.

They are also not custom implementations that behave like `std::lcm`; they actually call `std::lcm`.

The original plan was to call them through C++ Interop, but that was abandoned after some difficulty, so they are exposed with `extern "C"` and called through C Interop.

```swift
import AcFoundation

print(gcd(12,16)) // 4

print(lcm(12,16)) // 48

```

#### Partial Import

If you only want to use CxxWrapped features, import the following module.

```swift
import CxxWrapped
```

---

### CharacterUtil

For string problems, you need to choose between Swift strings, arrays of `Character`, and arrays of `UInt8`. Each has advantages and disadvantages, but this library recommends arrays of `Character` during contests.

When using arrays of characters, writing character loops is a little cumbersome, and lexicographical comparison is not obvious.

This module first adds `Stridable` conformance to `Character`, limited to ASCII characters.

This is useful because it lets you write character loops as follows.

```swift
import AcFoundation

for c: Character in "a"..."z" {
  print(c) // prints a through z in order
}
```

This module also adds lexicographical comparison operators to arrays of `Character`.

```swift
import AcFoundation

print(Array("abc") < Array("abd")) // true
```

To use this module, import it individually near the beginning of your source file.
(It is excluded from the umbrella import because adding `readLine` functions may make type annotations inconvenient.)

```swift
import CharacterUtil
```
---

### UInt8Util

For string problems, you need to choose between Swift strings, arrays of `Character`, and arrays of `UInt8`. Each has advantages and disadvantages, and this library recommends arrays of `Character` during contests. That said, arrays of `UInt8` can be easier to handle for people used to C or C++. Since null-terminated `cString`-related methods have started to become deprecated, this library recommends `UInt8` rather than `CChar`.

One inconvenience when using `UInt8` is that character literals cannot be used directly. This module adds extensions to cover that, allowing code like this.

```swift
let c: UInt8 = "A"
```

This module also adds lexicographical comparison operators to arrays of `UInt8`.

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)
print(abc < abd) // true
```

It also adds several properties equivalent to `Character` properties.

To use this module, import it individually near the beginning of your source file.

```swift
import UInt8Util
```

---

### StringUtil

For string problems, you need to choose between Swift strings, arrays of `Character`, and arrays of `UInt8`. Each has advantages and disadvantages, and this library recommends arrays of `Character` during contests. That said, forcing this on people who are not used to it is harsh, while Swift strings cannot be indexed by integers, which is painful for beginners. For that reason, this module provides convenient methods for strings. Please use them with the understanding that they are intended for beginners. Swift strings are very rich, and in competitive programming they can easily cause TLE. Please keep that in mind as well.

Use this when you want to write ABC A and B problems comfortably.

```swift
let s = "abcdef"
// Get one character
print(s[0]) // "a"

// Get substrings
print(s[0..<s.count]) // "abcdef"
print(s[0..<s.count]) // "abcdef"
print(s[0...]) // "abcdef"
print(s[..<s.count]) // "abcdef"
print(s[2..<4]) // "cd"
print(s[2...]) // "cdef"
print(s[..<4]) // "abcd"
print(s[...4]) // "abcde"
```

To use this module, import it individually near the beginning of your source file.

```swift
import StringUtil
```

---

### Miscellaneous

These are utilities that do not fit cleanly into the other categories.

#### Partial Import

```swift
import Miscellaneous
```

---

### Convinience

This module is for shortcuts. It is provided only through an individual import.

```swift
import Convinience
```

---

### MT19937

This is a Mersenne Twister, a pseudorandom number generator.
Use it when you need reproducible randomness, such as in AHC.

```swift
var mt = mt19937_64(seed: 0)
let randomInteger = Int.random(in: Int.min...Int.max, using: &mt)
let randomDouble = Double.random(in: 0...1, using: &mt)
```

It is provided only through an individual import.

```swift
import MT19937
```

---

## Other Notes

To make `modint` or `BigInt` usable with IOReader, the following code is required.

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

Depending on the constraints, the following can provide a little more speed.

```swift
// Available when the input constraints range from Int.min to Int.max
extension BigInt: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

```swift
// Available when the input constraints range from 0 to less than mod
extension static_modint: @retroactive IOUnsignedIntegerConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: UInt) -> Self { .init(rawValue: from) }
}
```

---

## `TestingUtil` for Local Tests

`TestingUtil` is a helper target for local test code, not for submitted solutions. It is not available in online judge environments such as AtCoder, so do not write `import TestingUtil` in code you submit.

It is intended for running your submitted-style `solve()` function from tests, feeding standard input, and checking captured standard output as a string.

```swift
.testTarget(name: "<test-target>", dependencies: [
  .product(name: "TestingUtil", package: "swift-ac-foundation")
])
```

```swift
import TestingUtil
import XCTest

final class SolverTests: XCTestCase {
  func testSample() throws {
    let runner = SolverRunner {
      solve()
    }

    XCTAssertEqual(try runner.run(input: "3\n1 2 3\n"), "6")
  }
}
```

---

## License

This library is provided under the CC0-1.0 license, but includes some code under the Apache 2.0 License.
