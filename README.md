# swift-ac-foundation

English | [日本語](README.ja.md)

[![Swift](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-foundation/actions/workflows/swift.yml)  
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## Usage

To use **swift-ac-foundation** in a SwiftPM project, add the following to your `Package.swift`:

```swift
.package(
  url: "https://github.com/narumij/swift-ac-foundation",
  branch: "compatible/AtCoder/2025"),
```

Tag-based specification may fail due to `unsafeFlags`. Use a specific revision if needed.

Add `AcFoundation` to your target:

```swift
.target(name: "<target>", dependencies: [
  .product(name: "AcFoundation", package: "swift-ac-foundation")
]),
```

Import:

```swift
import AcFoundation
```

---

## Contents

### IOReader

#### Quick usage

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

Equivalent to (but avoids intermediate strings):

```swift
let A = readLine()!.split(separator: " ").map { Int($0)! }
let G = readLine()!.split(separator: " ").map { String($0) }
let H = readLine()!.split(separator: " ").map { Array($0) }
```

#### Details

Adds `stdin` and `read()` for:

- Integers
- Floating point
- String
- `[Character]`
- `[UInt8]`

```swift
let N: Int = Int.stdin
let D: Double = Double.stdin
let S: String = String.stdin
let T: [Character] = [Character].stdin
let U: [UInt8] = [UInt8].stdin
```

#### Examples

Pair:

```swift
let (H, W): (Int, Int) = stdin()
```

Array:

```swift
let N: Int = Int.stdin
let A: [Int] = (0..<N).map { .stdin }
```

Query:

```swift
let Q: Int = Int.stdin
for _ in 0..<Q {
  switch Int.stdin {
    case 1:
      let (A, B) = (Int.stdin, Int.stdin)
    case 2:
      let C = Int.stdin
    default:
      break
  }
}
```

#### Helpers

```swift
let A = [Int].stdin(columns: N)
let G = [String].stdin(rows: H, columns: W)
let H = [[Character]].stdin(rows: H, columns: W)
```

#### Partial import

```swift
import IOReader
```

#### Notes

Optimized for minimizing:

- string splitting
- copying
- conversions

Faster than `readLine()` for numeric-heavy input.

But for very long single-line strings, `readLine()` is faster.

---

### IOUtil

Provides `TextOutputStream` for `print(to:)`.

```swift
import Foundation
import IOUtil

print("Hello", to: &FileOutputStream.standardError)
```

Includes `fastPrint` for integers.

```swift
import IOUtil
```

---

### Bisect

Python-like bisect.

```swift
let sortedList = [1, 4, 8, 100, 1000]
print(sortedList.bisectLeft(99)) // 3
```

```swift
import Bisect
```

---

### Pack

Tuple-like key for dictionaries.

```swift
import AcFoundation

let (_, M): (Int, Int) = stdin()
var m: [Pack<Int, Int>: Int] = [:]
var ans = 0

for _ in 0..<M {
  var (u, v): (Int, Int) = stdin()
  if u == v {
    ans += 1
    continue
  }
  if u > v { swap(&u, &v) }
  m[.init(u, v), default: 0] += 1
}

m.forEach { ans += $0.value - 1 }
print(ans)
```

```swift
import Pack
```

---

### CxxWrapped

Uses real `std::gcd` / `std::lcm`.

```swift
import AcFoundation

print(gcd(12,16))
print(lcm(12,16))
```

```swift
import CxxWrapped
```

---

### CharacterUtil

```swift
import CharacterUtil

for c: Character in "a"..."z" {
  print(c)
}

print(Array("abc") < Array("abd"))
```

---

### UInt8Util

```swift
import UInt8Util

let c: UInt8 = "A"

let abc = "abc".compactMap(\.asciiValue)
let abd = "abd".compactMap(\.asciiValue)
print(abc < abd)
```

---

### StringUtil

```swift
import StringUtil

let s = "abcdef"
print(s[0])
print(s[2..<4])
```

⚠️ May be slow (TLE risk)

---

### Miscellaneous

```swift
import Miscellaneous
```

---

### Convinience

```swift
import Convinience
```

---

### MT19937

```swift
import MT19937

var mt = mt19937_64(seed: 0)
let x = Int.random(in: Int.min...Int.max, using: &mt)
```

---

## Other

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

---

## License

CC0-1.0 (includes some Apache 2.0 code)
