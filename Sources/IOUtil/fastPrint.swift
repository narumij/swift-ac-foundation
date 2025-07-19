@preconcurrency import Foundation

extension UnsafeMutableBufferPointer where Element == UInt8 {

  @inlinable
  @inline(__always)
  func _print<I>(_ x: I) where I: FixedWidthInteger {
    let buf = baseAddress!
    var x = x
    var i = 0
    repeat {
      let r: I
      (x, r) = x.quotientAndRemainder(dividingBy: 10)
      buf[i] = 0x30 | UInt8(r)
      i += 1
    } while x > 0
    while i > 0 {
      i -= 1
      putchar_unlocked(Int32(buf[i]))
    }
  }

  @inlinable
  @inline(__always)
  func print<I>(_ x: I) where I: FixedWidthInteger & SignedInteger {
    if x < 0 {
      putchar_unlocked(0x2D)  // '-'
      let (x, r) = x.quotientAndRemainder(dividingBy: 10)
      _print(-x)  // 一桁削らないとInt.minは符号反転でInt.maxからあふれる
      putchar_unlocked(0x30 | Int32(-r))
    } else {
      _print(x)
    }
  }

  @inlinable
  @inline(__always)
  func print<I>(_ x: I) where I: FixedWidthInteger & UnsignedInteger {
    _print(x)
  }
}

@inlinable
@inline(__always)
public func fastPrint<I>(_ x: I, terminater: Int32? = 0x0A)
where I: FixedWidthInteger & SignedInteger {
  withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 39) { buf in
    buf.print(x)
  }
  if let terminater {
    putchar_unlocked(terminater)
  }
}

@inlinable
@inline(__always)
public func fastPrint<I>(_ x: I, terminater: Int32? = 0x0A)
where I: FixedWidthInteger & UnsignedInteger {
  withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 39) { buf in
    buf.print(x)
  }
  if let terminater {
    putchar_unlocked(terminater)
  }
}

@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C, separator: Int32 = 0x20, terminater: Int32 = 0x0A)
where
  C: Collection, C.Element == I, C.Index == Int,
  I: FixedWidthInteger & SignedInteger
{
  withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 39) { buf in
    for i in 0..<a.count {
      buf.print(a[i])
      putchar_unlocked(i == a.count - 1 ? terminater : separator)
    }
  }
}

@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C, separator: Int32 = 0x20, terminater: Int32 = 0x0A)
where
  C: Collection, C.Element == I, C.Index == Int,
  I: FixedWidthInteger & UnsignedInteger
{
  withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 39) { buf in
    for i in 0..<a.count {
      buf.print(a[i])
      putchar_unlocked(i == a.count - 1 ? terminater : separator)
    }
  }
}
