import Foundation

@usableFromInline
nonisolated(unsafe)
  let raw =
  UnsafeMutableRawPointer.allocate(
    byteCount: 40,
    alignment: MemoryLayout<UInt32>.alignment
  )

@usableFromInline
nonisolated(unsafe)
  var printBuffer8: UnsafeMutableBufferPointer<UInt8>
{
  .init(
    start: raw.assumingMemoryBound(to: UInt8.self),
    count: 40
  )
}

@usableFromInline
nonisolated(unsafe)
  var printBuffer32: UnsafeMutableBufferPointer<UInt32>
{
  .init(
    start: raw.assumingMemoryBound(to: UInt32.self),
    count: 10
  )
}

@inlinable
@inline(__always)
func store4(_ value: UInt32, _ byteOffset: Int) {

  assert(byteOffset & 3 == 0)

  printBuffer32[byteOffset >> 2] = value
}

@inlinable
func write1to4Digits(_ x: Int, _ i: Int) -> Int {

  var i = i

  let width: Int

  if x >= 1000 {
    width = 4
  } else if x >= 100 {
    width = 3
  } else if x >= 10 {
    width = 2
  } else {
    width = 1
  }

  i &-= width

  let value = digit4u32[x]

  let bytes = withUnsafeBytes(of: value) {
    $0
  }

  let start = 4 &- width

  for n in 0..<width {
    printBuffer8[i &+ n] = bytes[start &+ n]
  }

  return i
}

@inlinable
func write1to8Digits(_ x: Int, _ i: Int) -> Int {

  if x < 10_000 {
    return write1to4Digits(x, i)
  }

  var i = i

  let (hi, lo) = x.quotientAndRemainder(dividingBy: 10_000)

  i &-= 8

  store4(digit4u32[hi], i)
  store4(digit4u32[lo], i &+ 4)

  let width: Int

  if hi >= 1000 {
    width = 4
  } else if hi >= 100 {
    width = 3
  } else if hi >= 10 {
    width = 2
  } else {
    width = 1
  }

  return i &+ (4 &- width)
}

@inlinable
func write8Digits(_ x: Int, _ i: Int) -> Int {

  var i = i

  let (hi, lo) = x.quotientAndRemainder(dividingBy: 10_000)

  i &-= 8

  store4(digit4u32[hi], i)
  store4(digit4u32[lo], i &+ 4)

  return i
}

@inlinable
public func _fastPrint(_ value: Int64) {

  if value < 0 {
    Foundation.putchar_unlocked(45)
    printNegative(-value)
  } else {
    printPositive(UInt64(value))
  }

  Foundation.putchar_unlocked(10)
}

@inlinable
func printPositive(_ x: UInt64) {

  var i = 40

  let (a, r1) = x.quotientAndRemainder(dividingBy: 100_000_000)

  if a == 0 {

    i = write1to8Digits(Int(x), i)

  } else {

    let (b, r2) = a.quotientAndRemainder(dividingBy: 100_000_000)

    i = write8Digits(Int(r1), i)

    if b == 0 {

      i = write1to8Digits(Int(a), i)

    } else {

      i = write8Digits(Int(r2), i)
      i = write1to8Digits(Int(b), i)
    }
  }

  fwrite(
    printBuffer8.baseAddress! + i,
    1,
    40 &- i,
    stdout
  )
}

@inlinable
func printNegative(_ x: Int64) {

  var i = 40

  let (a, r1) = x.quotientAndRemainder(dividingBy: 100_000_000)

  if a == 0 {

    i = write1to8Digits(Int(x), i)

  } else {

    let (b, r2) = a.quotientAndRemainder(dividingBy: 100_000_000)

    i = write8Digits(Int(r1), i)

    if b == 0 {

      i = write1to8Digits(Int(a), i)

    } else {

      i = write8Digits(Int(r2), i)
      i = write1to8Digits(Int(b), i)
    }
  }

  fwrite(
    printBuffer8.baseAddress! + i,
    1,
    40 &- i,
    stdout
  )
}
