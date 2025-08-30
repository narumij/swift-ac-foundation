import Foundation
import _FastPrint

@inlinable
@inline(__always)
public func fastPrint<I>(_ x: I, terminater: Int32? = 0x0A)
where I: FixedWidthInteger & SignedInteger {
  ___print_int(Int64(x))
  if let terminater {
    putchar_unlocked(terminater)
  }
}

@inlinable
@inline(__always)
public func fastPrint<I>(_ x: I, terminater: Int32? = 0x0A)
where I: FixedWidthInteger & UnsignedInteger {
  ___print_uint(UInt64(x))
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
  for i in 0..<a.count {
    ___print_int(Int64(a[i]))
    putchar_unlocked(i == a.count - 1 ? terminater : separator)
  }
}

@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C, separator: Int32 = 0x20, terminater: Int32 = 0x0A)
where
  C: Collection, C.Element == I, C.Index == Int,
  I: FixedWidthInteger & UnsignedInteger
{
  for i in 0..<a.count {
    ___print_uint(UInt64(a[i]))
    putchar_unlocked(i == a.count - 1 ? terminater : separator)
  }
}

@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C,_ transform: (C.Element) -> I, separator: Int32 = 0x20, terminater: Int32 = 0x0A)
where
  C: Collection, C.Index == Int,
  I: FixedWidthInteger & SignedInteger
{
  for i in 0..<a.count {
    ___print_int(Int64(transform(a[i])))
    putchar_unlocked(i == a.count - 1 ? terminater : separator)
  }
}

@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C,_ transform: (C.Element) -> I,  separator: Int32 = 0x20, terminater: Int32 = 0x0A)
where
  C: Collection, C.Index == Int,
  I: FixedWidthInteger & UnsignedInteger
{
  for i in 0..<a.count {
    ___print_uint(UInt64(transform(a[i])))
    putchar_unlocked(i == a.count - 1 ? terminater : separator)
  }
}
