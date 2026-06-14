# swift-ac-foundation

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

English | [日本語](README.ja.md)

## Usage

To use swift-ac-foundation in a SwiftPM project, add the following entry to `dependencies` in `Package.swift`.

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
   branch: "compatible/AtCoder/2025"),
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

## Branch Strategy

| Branch | Recommended | Status | Description |
|----------|----------|----------|----------|
| `compatible/AtCoder/2025` | ⭐ | Maintained | Recommended branch compatible with AtCoder 2025 |
| `release/AtCoder/2025` | | Frozen | Snapshot deployed on AtCoder 2025 |
| `main` | | Active Development | Development branch for the next release |

### Which branch should I use?

Normally, use `compatible/AtCoder/2025`.

`release/AtCoder/2025` preserves the state deployed on AtCoder. As a rule, it does not change.

`compatible/AtCoder/2025` is maintained while preserving compatibility with AtCoder 2025, including documentation improvements, deprecation annotations, and additional cautions.

`main` is the development branch for the next release.

---

## Contents

### IOReader

IOReader is a token-based input library for standard input.
It keeps input code very concise, making it easier to focus on the problem itself.
Compared with `readLine()`-based input, it avoids the cost of intermediate strings and manual splitting.
It can also be combined with your own input helpers to reduce boilerplate.

```swift
let N = Int.stdin
let A = [Int].stdin(columns: N)
let (H, W): (Int, Int) = stdin()
let S = [String].stdin(rows: H, columns: W)
```

Tokens are separated by spaces, tabs, newlines, and similar whitespace.
Strings and characters assume ASCII input.

Detailed usage is split across the following documents.

- [IOReader Concepts](Documents/IOReaderConcepts.md): start here if you want to understand how it differs from `readLine()`
- [IOReader Recipes](Documents/IOReaderRecipes.md): practical input examples
- [IOReader Reference](Documents/IOReaderReference.md): supported types and detailed APIs

If you only want IOReader features, you can import `IOReader` directly.

---

### IOReaderExtra

IOReaderExtra adds `stdin` support for types that depend on external libraries, newer platform features, or optional helper modules.
It is not re-exported by `AcFoundation`; import it directly when you want to read these types from standard input.

```swift
import BigInt
import IOReaderExtra
import Pack

let x = BigInt.stdin
let a: Pack2<Int, String> = .stdin
let v = SIMD3<Int>.stdin
```

| Type | Notes |
|---|---|
| `BigInt` | Reads from a decimal string |
| `Int128`, `UInt128` | Available on macOS 15.0 or later |
| `static_modint`, `dynamic_modint` | AtCoder modint types |
| `Pack`, `Pack2`, `Pack3` | Available when the contained types support `stdin` |
| `SIMD2`, `SIMD3`, `SIMD4` | Available when `Scalar` supports `stdin` |
| `InlineArray` | Available on macOS 26.0 or later when `Element` supports `stdin` |

---

### IOWriter

IOWriter provides `print` methods that format arrays as one line and arrays of arrays as multiple lines.

Numeric arrays are printed with spaces between elements, while character arrays are printed by joining the characters.

```swift
[1, 2, 3].print()        // 1 2 3
[1.5, 2.5].print()       // 1.5 2.5
(["A", "B", "C"] as [Character]).print() // ABC
```

Arrays of arrays are printed one element per line.

```swift
[[1, 2], [3, 4]].print()
// -> 1 2
//    3 4
```

```swift
([["#", "#"], ["#", "#"]] as [[Character]]).print()
// -> ##
//    ##
```

As with the standard `print` function, you can specify separators and terminators.

```swift
[1.5, 2.5].print(separator: ", ") // 1.5, 2.5
```

For arrays of arrays, the separator and terminator are applied to each row.

```swift
[[1, 2], [3, 4]].print(separator: ", ")
// -> 1, 2
//    3, 4
```

On macOS 26.0 or later, `print(separator:terminator:)` is also available for `InlineArray`.

#### Partial Import

```swift
import IOWriter
```

---

### IOUtil

IOUtil provides fast I/O helpers for keeping benchmark results from being dominated by input/output cost, and low-level pieces for building your own input/output routines.
It is available only through an individual import and is not the main input API for ordinary contest use.

```swift
import IOUtil
```

`fastPrint` writes integers and ASCII-like values through low-level output routines.
It supports signed and unsigned fixed-width integers, integer collections, `[UInt8]`, `[Int8]`, and `[Character]`.

```swift
fastPrint(123)
fastPrint([1, 2, 3])
fastPrint([1, 2, 3], separator: 0x0A)
fastPrint(asciiValues: Array("OK".utf8))
```

Sequences whose elements conform to `CustomStringConvertible` can be printed with separators.

```swift
[1, 2, 3].print()
[1, 2, 3].print(separator: ",")
```

`getline` exposes one input line as UTF-8 bytes.
`readIntLine()` and `readUIntLine()` read one line as an integer array.
These APIs are useful when you want to inspect line-buffer behavior or build a custom reader.

```swift
let values: [Int] = readIntLine()
let unsigned: [UInt] = readUIntLine()
```

`stderr` and `stdout` can also be used as `TextOutputStream` targets.

```swift
print("debug", to: &stderr)
```

---

### Bisect

This is a Swift port of Python's `bisect`. It performs fast binary searches on sorted collections and returns positions where values can be inserted while preserving order.

Specifically, `bisectLeft` returns the first position whose element is greater than or equal to the specified value, and `bisectRight` returns the first position whose element is greater than the specified value.

```swift
let sortedList = [1, 4, 8, 100, 1000]

print(sortedList.bisectLeft(99))  // 3: number of elements less than 99
print(sortedList.bisectRight(99)) // 3: number of elements less than or equal to 99
```

`bisectLeft(x)` returns the position to insert `x` on the left side of equal values, while `bisectRight(x)` returns the position on the right side. For arrays with duplicate values, the difference is the number of occurrences of `x`.

```swift
let values = [1, 2, 2, 2, 5]

let left = values.bisectLeft(2)
let right = values.bisectRight(2)

print(left)          // 1
print(right)         // 4
print(right - left)  // 3
```

You can pass `key` when you want to compare by a value extracted from each element instead of the element itself.

```swift
let pairs = [(score: 10, name: "a"), (score: 20, name: "b"), (score: 20, name: "c")]

print(pairs.bisectLeft(20) { $0.score })  // 1
print(pairs.bisectRight(20) { $0.score }) // 3
```

**Limiting the Search Range**  
You can also use it with `ArraySlice` and `Range`. The returned value is an index in the original collection, so note that a slice's `startIndex` is not necessarily 0.

```swift
let sortedList = [1, 4, 8, 100, 1000]
let slice = sortedList[1..<4]

print(slice.bisectLeft(99)) // 3
```

**Insertion While Preserving Sort Order**  
For `RangeReplaceableCollection`, `insortLeft` and `insortRight` insert directly at the searched position. The insertion itself moves array elements, so it is `O(n)`.

```swift
var values = [1, 2, 2, 5]
values.insortRight(2)

print(values) // [1, 2, 2, 2, 5]
```

#### Partial Import

If you only want Bisect features, import the module below.

```swift
import Bisect
```

---

### Pack

Swift tuples cannot be used directly as dictionary keys.

Therefore, when you want to use graph edges such as `(u, v)` or coordinates such as `(x, y)` in dictionaries or sets, you would normally need to define a dedicated struct and make it conform to `Hashable`.

`Pack` is a type for avoiding that boilerplate.

```swift
var edges: [Pack<Int, Int>: Int] = [:]

edges[.init(1, 2), default: 0] += 1
edges[.init(2, 3), default: 0] += 1
```

For example, in ABC393C, you can use it as follows to count duplicate edges.

```swift
import AcFoundation

let (_, M): (Int, Int) = stdin()

nonisolated(unsafe) var m: [Pack<Int, Int>: Int] = [:]
nonisolated(unsafe) var ans = 0

for _ in 0 ..< M {
  var (u, v): (Int, Int) = stdin()

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

`Pack` also supports `Comparable`, so it can be used in priority queues, Dijkstra's algorithm, and other situations that require ordered comparisons.

If compilation becomes problematic in your environment, use `Pack2` or `Pack3` instead.

#### Partial Import

If you only want Pack features, import the module below.

```swift
import Pack
```

---

### StringUtil

For string problems, there are several possible representations, including `String`, `[Character]`, and `[UInt8]`.

`StringUtil` is a helper module for cases where you want to use Swift's `String` directly.

Swift strings are powerful Unicode-aware values, so they do not support integer subscripts.

This can feel inconvenient for people who have just started competitive programming.

With this module, you can access strings using integer indices and ranges.

```swift
let s = "abcdef"

// Get one character
print(s[0]) // "a"

// Get substrings
print(s[0..<s.count]) // "abcdef"
print(s[0...])        // "abcdef"
print(s[..<s.count])  // "abcdef"

print(s[2..<4]) // "cd"
print(s[2...])  // "cdef"
print(s[..<4])  // "abcd"
print(s[...4])  // "abcde"
```

It is intended for cases where you first want to write a straightforward solution, such as ABC A and B problems.

On the other hand, because Swift's `String` is feature-rich, it can be more expensive than `[Character]` or `[UInt8]`.

For large inputs or problems that operate heavily on strings, consider another representation.

#### Usage

This module must be imported individually.

```swift
import StringUtil
```

The right representation for string problems depends on the problem and your preferences.

For that reason, `String`-oriented features are not included in `AcFoundation`; use them only when needed.

---

### CharacterUtil

For string problems, you need to choose between `String`, `[Character]`, and `[UInt8]`.

Each has pros and cons, but this library assumes `[Character]` as the easy-to-handle default during contests.

`CharacterUtil` provides helpers that make implementations using `Character` and `[Character]` a little easier to write.

First, it makes ASCII `Character` values usable in ranges.

```swift
import CharacterUtil

for c: Character in "a"..."z" {
  print(c)
}
```

This lets you enumerate alphabets and digits concisely.

It also provides lexicographical comparison operators for `[Character]`.

```swift
import CharacterUtil

print(Array("abc") < Array("abd")) // true
```

Even when you convert strings to arrays, you can compare them lexicographically in a string-like way.

#### Usage

This module must be imported individually.

```swift
import CharacterUtil
```

It is not included in `AcFoundation`.

Some people use `String` for string problems, while others use `[Character]` or `[UInt8]`.

This library keeps `Character`-oriented features as an individual import so users can choose freely.

---

### UInt8Util

For string problems, there are several possible representations, including `String`, `[Character]`, and `[UInt8]`.

`UInt8Util` provides useful features for cases where you use `[UInt8]`.

Swift does not have character literals for `UInt8`, which can be inconvenient when handling ASCII characters.

With this module, you can create `UInt8` values from character literals as follows.

```swift
let c: UInt8 = "A"
```

It also provides lexicographical comparison operators for `[UInt8]`.

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)

print(abc < abd) // true
```

It also adds several `Character`-like helpers that are useful when handling ASCII strings.

#### Usage

This module must be imported individually.

```swift
import UInt8Util
```

The right representation for string problems depends on the problem and your preferences.

For that reason, `UInt8`-oriented features are not included in `AcFoundation`; use them only when needed.

---

### Miscellaneous

Miscellaneous collects short, common routines often seen on AtCoder.
It is also available through `AcFoundation`, but you can import it individually when you only need these features.

It mainly provides functions that convert boolean results directly into output strings, along with small integer helpers.

```swift
print(Yes(a == b))       // Yes if true, No if false
print(NO(x < y))         // NO if true, YES if false
print(Takahashi(win))    // Takahashi if true, Aoki if false
print(correct(ok))       // correct if true, incorrect if false
```

For three states such as win, lose, and draw, you can use `Bool?`.

```swift
let result: Bool? = nil
print(TakahashiAokiDraw(result)) // Draw
```

For integers, it provides `floor`, `ceil`, and `mod` functions that are convenient for division involving negative values, plus commonly used modulus constants.

```swift
print(floor(-3, 2)) // -2
print(ceil(-3, 2))  // -1
print(mod(-3, 2))   // 1

let mod = MOD_998_244_353 // common modulus in AtCoder Library
```

#### Partial Import

```swift
import Miscellaneous
```

---

### Convenience

Convenience is a helper module for writing shorter submitted code.
It is also available through `AcFoundation`, but you can import it individually when you want to limit the enabled features.

It collects APIs that make standard-library operations shorter, such as array and string repetition, prefix sums, aggregation, range loops, and bit operations.

```swift
let zeros = [0] * 5              // [0, 0, 0, 0, 0]
let grid = [0] * (3, 4)          // 3 x 4 two-dimensional array
let text = "ab" * 3              // "ababab"

var a = [1, 2]
a.resize(5, 0)                   // [1, 2, 0, 0, 0]
```

`Sequence` gains helpers for sums, products, counting, transposition, and similar operations.

```swift
print([1, 2, 3].sum())           // 6
print([2, 3, 4].product())       // 24
print([true, true].all)          // true
print([false, true].any)         // true
print([1, 2, 1, 3].count(1))     // 2

let matrix = [[1, 2, 3], [4, 5, 6]]
print(matrix.transposed())       // [[1, 4], [2, 5], [3, 6]]
```

Prefix sums are available for one to three dimensions.

For one-dimensional prefix sums, also consider `reductions(0, +)` from `swift-algorithms` when it is available.

```swift
let s = prefixSum([1, 2, 3])
print(s)                         // [0, 1, 3, 6]

// swift-algorithms
let t = [1, 2, 3].reductions(0, +)
print(Array(t))                  // [0, 1, 3, 6]

let gridSum = prefixSum([[1, 2], [3, 4]])
```

Integers gain `range` and `rep`, a power operator, bit subscripts, and other helpers.

```swift
for i in 5.range {
  print(i)                       // 0 through 4
}

let squares = 5.rep { i in i * i }
print(2 ** 10)                   // 1024

var bit = 0
bit[3] = true
print(bit)                       // 8
```

There are also operators for descending loops and loops that include the end value.

```swift
for i in 0 ..<= 3 {
  print(i)                       // 0, 1, 2, 3
}

for i in 3 ..>= 0 {
  print(i)                       // 3, 2, 1, 0
}
```

Empty ranges are handled safely, so you can write loops without worrying about that condition.

#### Partial Import

```swift
import Convenience
```

---

### CxxWrapped

This module is a wrapper for using C++ standard library `std::gcd` and `std::lcm` from Swift.

They are not custom implementations; they actually call `std::gcd` and `std::lcm` from the C++ standard library.

```swift
import AcFoundation

print(gcd(12, 16)) // 4
print(lcm(12, 16)) // 48
```

Currently, the C++ side exposes them through `extern "C"`, and Swift calls them through C Interop.

#### Partial Import

If you only want CxxWrapped features, import the module below.

```swift
import CxxWrapped
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

## `TestingUtil` for Local Tests

`TestingUtil` is a helper target for local test code, not for submitted solutions.

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

This library is provided under the CC0-1.0 license, but it includes some code licensed under the Apache 2.0 License.
