// library-checker用

@preconcurrency import Foundation

@inlinable
@inline(__always)
func ___write8Digits(
  _ value: UInt,
  _ pairs: UnsafePointer<UInt16>,
  _ base16: UnsafeMutablePointer<UInt16>,
  _ j: Int
) {
  let q = value / 10_000
  let lo = value &- q &* 10_000

  let a = q / 100
  let b = q &- a &* 100
  let c = lo / 100
  let d = lo &- c &* 100

  (base16 + j + 0).pointee = pairs[Int(bitPattern: a)]
  (base16 + j + 1).pointee = pairs[Int(bitPattern: b)]
  (base16 + j + 2).pointee = pairs[Int(bitPattern: c)]
  (base16 + j + 3).pointee = pairs[Int(bitPattern: d)]
}

@inlinable
@inline(__always)
func ___skipZeros8(_ value: UInt) -> Int {
  if value < 10 { return 7 }
  if value < 100 { return 6 }
  if value < 1_000 { return 5 }
  if value < 10_000 { return 4 }
  if value < 100_000 { return 3 }
  if value < 1_000_000 { return 2 }
  if value < 10_000_000 { return 1 }
  return 0
}

@inlinable
func ___printPositiveEight(_ value: UInt) {
  withUnsafeBytes(of: ___digitPairs16) { rawPairs in
    let pairs = rawPairs.baseAddress!.assumingMemoryBound(to: UInt16.self)

    let base8 = ___printBuffer8.baseAddress!
    let base16 = ___printBuffer16.baseAddress!

    var x = value
    var j = ___printBuffer16.count
    var r: UInt = 0

    repeat {
      let q: UInt
      (q, r) = x.quotientAndRemainder(dividingBy: 100_000_000)

      j &-= 4
      ___write8Digits(r, pairs, base16, j)

      x = q
    } while x != 0

    let i = (j << 1) &+ ___skipZeros8(r)

    fwrite(base8 + i, 1, ___printBuffer8.count &- i, stdout)
  }
}

@inlinable
func ___printNegativeEight(_ value: Int) {
  Foundation.putchar_unlocked(45)  // "-"

  withUnsafeBytes(of: ___digitPairs16) { rawPairs in
    let pairs = rawPairs.baseAddress!.assumingMemoryBound(to: UInt16.self)

    let base8 = ___printBuffer8.baseAddress!
    let base16 = ___printBuffer16.baseAddress!

    var x = value
    var j = ___printBuffer16.count
    var r = 0

    repeat {
      let q: Int
      (q, r) = x.quotientAndRemainder(dividingBy: 100_000_000)

      j &-= 4
      ___write8Digits(UInt(r), pairs, base16, j)

      x = q
    } while x != 0

    let i = (j << 1) &+ ___skipZeros8(UInt(r))

    fwrite(base8 + i, 1, ___printBuffer8.count &- i, stdout)
  }
}

@inlinable
public func ___printIntEight(_ value: Int) {
  if value < 0 {
    ___printNegativeEight(value)
  } else {
    ___printPositiveEight(UInt(value))
  }
}

@inlinable
public func ___printUIntEight(_ value: UInt) {
  ___printPositiveEight(value)
}
