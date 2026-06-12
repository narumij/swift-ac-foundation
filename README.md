# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

English | [日本語](README.ja.md)

## Usage

To use swift-ac-foundation in a SwiftPM project, add the following entry to `dependencies` in `Package.swift`.

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
   branch: "release/AtCoder/2025"),
```

Specifying a tag can be rejected by the build because this package uses C++ `unsafeFlags`. If you need a fixed version, specify a revision directly.

Add `AcFoundation` to the dependencies of your executable target.

```swift
.target(name: "<target>", dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]),
```

Then import it from your source code.

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

The `readLine()` methods are roughly equivalent to the following code, but they avoid creating intermediate Swift strings.

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

**Separators**  
Spaces, tabs, and newlines are treated as separators.

```swift
let N: Int = Int.stdin
let D: Double = Double.stdin
let S: String = String.stdin
let T: [Character] = [Character].stdin
let U: [UInt8] = [UInt8].stdin
```

**Example 1: Reading a Pair**  
For input such as `H W`, you can write any of the following.

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

**Example 2: Reading an Array**  
For an item count `N` followed by a sequence `A`, write the following. This also works for vertically or horizontally arranged data.

```swift
let N: Int = Int.stdin
let A: [Int] = (0..<N).map { .stdin }
```

**Example 3: Processing Queries**  
This is an example that reads `Q` queries and dispatches by query type.

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

When you want to specify the number of elements to read:

```swift
let A = [Int].stdin(columns: N)
let G = [String].stdin(rows: H, columns: W)
let H = [[Character]].stdin(rows: H, columns: W)
let I = [[UInt8]].stdin(rows: H, columns: W)
```

#### Partial Import

If you only want IOReader features, import the module below.

```swift
import IOReader
```

#### `read` and `stdin`

The underlying methods and functions follow the usual naming convention and use the verb `read` in their identifiers.

Convenience properties and methods that omit `try` use the identifier `stdin`.

One reason is that it is inspired by C++ `cin`.

Another reason is that very few people are likely to use `stdin` in this unusual way, so the name is unlikely to collide.

Resolving `ambiguous` errors during a contest is difficult, so this package tries to avoid them where possible.

Unusual identifiers are also easy to forget, and `stdin` seemed like the least bad option.

#### Notes

This IOReader is designed to minimize unnecessary string splitting, string copying, and numeric conversion overhead.  
When many numbers are provided, it can be faster than the standard `readLine()` approach.

On the other hand, if you need to read a very long entire line as a string, `readLine()` is faster.  
**Swift string processing can easily lead to TLE on some AtCoder problems, so choose the right tool for each problem.**

---

### IOUtil

**The stdout/stderr-based approach has been deprecated.**

This module provides `TextOutputStream` values for standard output and standard error that can be used with the `to:` parameter of `print`.
This makes it possible to write to standard error as follows.

```swift
import Foundation
import IOUtil

print("Hello, world!", to: &FileOutputStream.standardError)
```

It also provides `fastPrint`, an integer-focused output helper intended to reduce I/O overhead when comparing performance.

#### Partial Import

This module is available only through an individual import.

If you want to use IOUtil features, import the module below.

```swift
import IOUtil
```

---

### Bisect

This is a Swift port of Python's `bisect`, enabling binary search in Swift.

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

If you only want Bisect features, import the module below.

```swift
import Bisect
```

---

### Pack

Because SE-283 is frozen, tuples still cannot be used as dictionary keys.
For graph problems such as ABC393C, Swift also does not have a built-in equivalent of C++ `pair`, so you would otherwise need to write a custom struct and make it `Hashable` each time.
This package provides `Pack` so casual competitive programmers do not need that much protocol boilerplate.

With `Pack`, ABC393C can be written compactly as follows and should be accepted.

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

`Pack` also conforms to `Comparable`, so it can be used when writing Dijkstra and similar algorithms.

If compilation becomes problematic, try `Pack2` or `Pack3` as fallback types.

#### Partial Import

If you only want Pack features, import the module below.

```swift
import Pack
```

---

### CxxWrapped

This module provides `std::gcd` and `std::lcm`.

They are not approximations of `std::gcd` or custom `std::lcm` implementations; they actually call `std::gcd` and `std::lcm`.

The original plan was to call them through C++ Interop, but that did not work out easily, so they are exposed with `extern "C"` and called through C Interop.

```swift
import AcFoundation

print(gcd(12,16)) // 4

print(lcm(12,16)) // 48

```

#### Partial Import

If you only want CxxWrapped features, import the module below.

```swift
import CxxWrapped
```

---

### CharacterUtil

For string problems, you need to choose between Swift `String`, `[Character]`, and `[UInt8]`. Each has pros and cons, but this package recommends `[Character]` during contests.

When using character arrays, writing character loops can be somewhat tedious, and lexicographical comparison is not obvious.

This module first adds `Stridable` conformance to `Character` for ASCII characters.

That lets you write loops over characters like this.

```swift
import AcFoundation

for c: Character in "a"..."z" {
  print(c) // prints a through z in order
}
```

This module also adds lexicographical comparison operators to `[Character]`.

```swift
import AcFoundation

print(Array("abc") < Array("abd")) // true
```

To use this module, import it individually near the top of your source file.
(It is excluded from the umbrella import because adding `readLine` functions can make type annotations inconvenient.)

```swift
import CharacterUtil
```

---

### UInt8Util

For string problems, you need to choose between Swift `String`, `[Character]`, and `[UInt8]`. Each has pros and cons, and this package recommends `[Character]` during contests. That said, `[UInt8]` can be easier for people used to C or C++. Since null-terminated `cString`-related methods have started to become deprecated, this package prefers `UInt8` over `CChar`.

One inconvenience with `UInt8` is that character literals cannot be used directly. This module adds extensions to cover that, so you can write the following.

```swift
let c: UInt8 = "A"
```

This module also adds lexicographical comparison operators to `[UInt8]`.

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)
print(abc < abd) // true
```

It also provides several properties equivalent to `Character` properties.

To use this module, import it individually near the top of your source file.

```swift
import UInt8Util
```

---

### StringUtil

For string problems, you need to choose between Swift `String`, `[Character]`, and `[UInt8]`. Each has pros and cons, and this package recommends `[Character]` during contests. However, forcing that on beginners is harsh, while Swift strings do not support integer subscripts, which is also painful for beginners. This module adds convenience methods for strings. Use them with the understanding that they are intended for beginners. Swift strings are very rich, and in competitive programming they can easily cause TLE.

Use this when you want to solve ABC A or B problems comfortably.

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

To use this module, import it individually near the top of your source file.

```swift
import StringUtil
```

---

### Miscellaneous

This module contains utilities that do not fit cleanly into the other categories.

#### Partial Import

```swift
import Miscellaneous
```

---

### Convinience

This module is for shortcuts. It is available only through an individual import.

```swift
import Convinience
```

---

### MT19937

This is a Mersenne Twister pseudorandom number generator.
Use it when you need reproducible random numbers, such as in AHC.

```swift
var mt = mt19937_64(seed: 0)
let randomInteger = Int.random(in: Int.min...Int.max, using: &mt)
let randomDouble = Double.random(in: 0...1, using: &mt)
```

It is available only through an individual import.

```swift
import MT19937
```

---

## Notes

To make `modint` or `BigInt` work with IOReader, you need code like the following.

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

Depending on the constraints, the following can be slightly faster.

```swift
// Available when the input constraints are Int.min through Int.max
extension BigInt: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
```

```swift
// Available when the input constraints are 0 through less than mod
extension static_modint: @retroactive IOUnsignedIntegerConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: UInt) -> Self { .init(rawValue: from) }
}
```

---

## License

This library is provided under the CC0-1.0 license, but it includes some code licensed under the Apache 2.0 License.
