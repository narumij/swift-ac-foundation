# swift-ac-foundation

English | [日本語](README.ja.md)

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

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
|---|---|---|---|
| `compatible/AtCoder/2025` | Yes | Maintained | Recommended branch compatible with AtCoder 2025 |
| `release/AtCoder/2025` | | Frozen | Snapshot deployed on AtCoder 2025 |
| `main` | | Active Development | Development branch for the next release |

### Which branch should I use?

Normally, use `compatible/AtCoder/2025`.

`release/AtCoder/2025` preserves the state deployed on AtCoder. As a rule, it does not change.

`compatible/AtCoder/2025` is maintained while preserving compatibility with AtCoder 2025, including documentation improvements, deprecation annotations, and additional cautions.

`main` is the development branch for the next release.

---

## Contents

`AcFoundation` re-exports `IOReader`, `Bisect`, `Pack`, `CxxWrapped`, and `Miscellaneous`.
Other modules are available through individual imports.

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

### IOUtil

IOUtil contains low-level input/output helpers.
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

`getline` exposes one input line as UTF-8 bytes, and `readIntLine()` / `readUIntLine()` read one line as integer arrays.
These APIs are useful when you want to inspect line-buffer behavior or build a custom reader.

```swift
let values: [Int] = readIntLine()
let unsigned: [UInt] = readUIntLine()
```

`FileOutputStream` provides `TextOutputStream` values for standard output and standard error, but this API is deprecated in this compatibility branch.

```swift
print("debug", to: &FileOutputStream.standardError)
```

---

### Bisect

This is a Swift port of Python's `bisect`, enabling binary search in Swift.
It returns the insertion position that keeps a sorted collection sorted.

```swift
let sortedList = [1, 4, 8, 100, 1000]

print(sortedList.bisectLeft(99))  // 3
print(sortedList.bisectRight(99)) // 3
```

`bisectLeft(x)` returns the position to insert `x` before equal values, and `bisectRight(x)` returns the position after equal values.
For arrays with duplicates, the difference is the number of occurrences.

```swift
let values = [1, 2, 2, 2, 5]

let left = values.bisectLeft(2)
let right = values.bisectRight(2)

print(left)          // 1
print(right)         // 4
print(right - left)  // 3
```

You can pass `key` when the comparison value should be extracted from each element.

```swift
let pairs = [(score: 10, name: "a"), (score: 20, name: "b"), (score: 20, name: "c")]

print(pairs.bisectLeft(20) { $0.score })  // 1
print(pairs.bisectRight(20) { $0.score }) // 3
```

**Limiting the Search Range**  
You can use it with `ArraySlice` as well.
The returned value is an index in the original collection, so a slice's `startIndex` is not always `0`.

```swift
let sortedList = [1, 4, 8, 100, 1000]
let slice = sortedList[1..<4]

print(slice.bisectLeft(99)) // 3
```

**Sorted Insertion**
`RangeReplaceableCollection` supports `insortLeft` / `insortRight`, which insert at the searched position.
The search is logarithmic, but insertion into an array still moves elements and is `O(n)`.

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

Swift tuples still cannot be used directly as dictionary keys.
For graph edges `(u, v)`, coordinates `(x, y)`, and similar values, you would otherwise need to define a custom struct and make it `Hashable` each time.

`Pack` is a small wrapper type for that use case.

```swift
var edges: [Pack<Int, Int>: Int] = [:]

edges[.init(1, 2), default: 0] += 1
edges[.init(2, 3), default: 0] += 1
```

For example, ABC393C can be written compactly as follows.

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

`Pack` also conforms to `Comparable`, so it can be used when ordered comparison is needed.

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

print(gcd(12, 16)) // 4
print(lcm(12, 16)) // 48
```

#### Partial Import

If you only want CxxWrapped features, import the module below.

```swift
import CxxWrapped
```

---

### Miscellaneous

Miscellaneous contains small utilities that are commonly useful in AtCoder-style code.
It is re-exported by `AcFoundation`, and it can also be imported individually.

```swift
print(Yes(a == b))       // true -> Yes, false -> No
print(NO(x < y))         // true -> NO, false -> YES
print(Takahashi(win))    // true -> Takahashi, false -> Aoki
```

It also provides integer helpers for floor division, ceiling division, Euclidean modulo, and common modulus constants.

```swift
print(floor(-3, 2)) // -2
print(ceil(-3, 2))  // -1
print(mod(-3, 2))   // 1

let mod = MOD_998_244_353
```

#### Partial Import

```swift
import Miscellaneous
```

---

### Convenience

Convenience contains shortcuts for writing submission code compactly.
It is available only through an individual import.

```swift
import Convenience
```

It includes repeated array and string construction, resizing, prefix sums, aggregation helpers, range-loop operators, and bit subscripts.

```swift
let zeros = [0] * 5              // [0, 0, 0, 0, 0]
let grid = [0] * (3, 4)          // 3 x 4 array
let text = "ab" * 3             // "ababab"

var a = [1, 2]
a.resize(5)                     // [1, 2, 0, 0, 0]
```

`Sequence` gains helpers for printing, sums, products, counts, boolean checks, bitwise aggregation, and transposition.

```swift
[1, 2, 3].print()
[1, 2, 3].print(separator: ",")

print([1, 2, 3].sum())
print([2, 3, 4].product())
print([true, true].all)
print([false, true].any)
print([1, 2, 1, 3].count(1))

let matrix = [[1, 2, 3], [4, 5, 6]]
print(matrix.transposed())       // [[1, 4], [2, 5], [3, 6]]
```

Prefix sums are available for one, two, and three dimensions.

```swift
let s = prefixSum([1, 2, 3])
print(s)                         // [0, 1, 3, 6]

let gridSum = prefixSum([[1, 2], [3, 4]])
```

Integers gain a power operator, loop helpers, and bit subscripts.

```swift
print(2 ** 10)                   // 1024

for i in 0 ..<= 3 {
  print(i)                       // 0, 1, 2, 3
}

for i in 3 ..>= 0 {
  print(i)                       // 3, 2, 1, 0
}

var bit = 0
bit[3] = true
print(bit)                       // 8
```

---

### StringUtil

StringUtil is a helper module for cases where you want to use Swift `String` directly.
Swift strings are Unicode-aware and powerful, but they do not support integer subscripts.
That can be awkward for beginners in competitive programming.

This module adds integer and range subscripts to strings.

```swift
import StringUtil

let s = "abcdef"

print(s[0])          // "a"
print(s[0..<s.count]) // "abcdef"
print(s[0...])       // "abcdef"
print(s[..<s.count]) // "abcdef"
print(s[2..<4])      // "cd"
print(s[2...])       // "cdef"
print(s[..<4])       // "abcd"
print(s[...4])       // "abcde"
```

Use it for small problems where straightforward implementation matters more than string-processing performance.
For large inputs or frequent string operations, consider `[Character]` or `[UInt8]` instead.

---

### CharacterUtil

CharacterUtil provides helpers for writing code with `Character` and `[Character]`.

It adds `Stridable` conformance to `Character` for ASCII characters.

```swift
import CharacterUtil

for c: Character in "a"..."z" {
  print(c)
}
```

It also adds lexicographical comparison operators to `[Character]`.

```swift
import CharacterUtil

print(Array("abc") < Array("abd")) // true
```

This module is available only through an individual import.

---

### UInt8Util

UInt8Util provides helpers for code that represents strings as `[UInt8]`.

Swift does not have character literals for `UInt8`, so this module lets you write ASCII values like this.

```swift
import UInt8Util

let c: UInt8 = "A"
```

It also adds lexicographical comparison operators to `[UInt8]`.

```swift
let abc: [UInt8] = "abc".compactMap(\.asciiValue)
let abd: [UInt8] = "abd".compactMap(\.asciiValue)

print(abc < abd) // true
```

It also provides several properties equivalent to `Character` properties.

This module is available only through an individual import.

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
It is not available in online judge environments such as AtCoder, so do not write `import TestingUtil` in code you submit.

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
