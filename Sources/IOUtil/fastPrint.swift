@preconcurrency import Foundation
@preconcurrency import _FastIO

public protocol FastPrintable { }

public protocol FastPrintableInteger: FixedWidthInteger & FastPrintable { }

extension Int: FastPrintableInteger { }
extension Int16: FastPrintableInteger { }
extension Int32: FastPrintableInteger { }
extension Int64: FastPrintableInteger { }
extension UInt: FastPrintableInteger { }
extension UInt16: FastPrintableInteger { }
extension UInt32: FastPrintableInteger { }
extension UInt64: FastPrintableInteger { }

@inlinable
@inline(__always)
public func fastPrint<I>(_ x: I, terminator: Int32? = 0x0A)
where I: FastPrintableInteger & SignedInteger {
  ___print_int(Int64(x))
  if let terminator {
    putchar_unlocked(terminator)
  }
}

@inlinable
@inline(__always)
public func fastPrint<I>(_ x: I, terminator: Int32? = 0x0A)
where I: FastPrintableInteger & UnsignedInteger {
  ___print_uint(UInt64(x))
  if let terminator {
    putchar_unlocked(terminator)
  }
}

/// 数字出力用です。文字列にはfastPrint(asciiValues:)をお使いください
@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C, separator: Int32 = 0x20, terminator: Int32 = 0x0A)
where
  C: Collection, C.Element == I, C.Index == Int,
  I: FastPrintableInteger & SignedInteger
{
  for i in 0..<a.count {
    ___print_int(Int64(a[i]))
    putchar_unlocked(i == a.count - 1 ? terminator : separator)
  }
}

/// 数字出力用です。文字列にはfastPrint(asciiValues:)をお使いください
@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C, separator: Int32 = 0x20, terminator: Int32 = 0x0A)
where
  C: Collection, C.Element == I, C.Index == Int,
  I: FastPrintableInteger & UnsignedInteger
{
  for i in 0..<a.count {
    ___print_uint(UInt64(a[i]))
    putchar_unlocked(i == a.count - 1 ? terminator : separator)
  }
}

/// 数字出力用です。文字列にはfastPrint(asciiValues:)をお使いください
@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C,_ transform: (C.Element) -> I, separator: Int32 = 0x20, terminator: Int32 = 0x0A)
where
  C: Collection, C.Index == Int,
  I: FastPrintableInteger & SignedInteger
{
  for i in 0..<a.count {
    ___print_int(Int64(transform(a[i])))
    putchar_unlocked(i == a.count - 1 ? terminator : separator)
  }
}

/// 数字出力用です。文字列にはfastPrint(asciiValues:)をお使いください
@inlinable
@inline(__always)
public func fastPrint<C, I>(_ a: C,_ transform: (C.Element) -> I,  separator: Int32 = 0x20, terminator: Int32 = 0x0A)
where
  C: Collection, C.Index == Int,
  I: FastPrintableInteger & UnsignedInteger
{
  for i in 0..<a.count {
    ___print_uint(UInt64(transform(a[i])))
    putchar_unlocked(i == a.count - 1 ? terminator : separator)
  }
}

// MARK: -

@inlinable
@inline(__always)
public func fastPrint(asciiValues s: [Int8], terminator: Int32? = 0x0A) {
  for c in s where c != 0 {
    putchar_unlocked(c)
  }
  if let terminator {
    putchar_unlocked(terminator)
  }
}

@inlinable
@inline(__always)
public func fastPrint(asciiValues s: [UInt8], terminator: Int32? = 0x0A) {
  for c in s {
    putchar_unlocked(c)
  }
  if let terminator {
    putchar_unlocked(terminator)
  }
}

@inlinable
@inline(__always)
public func fastPrint(_ s: [Character], terminator: Int32? = 0x0A) {
  for c in s {
    putchar_unlocked(c)
  }
  if let terminator {
    putchar_unlocked(terminator)
  }
}

@inlinable
@inline(__always)
func putchar_unlocked(_ c: Int8) {
  putchar_unlocked(Int32(c))
}

@inlinable
@inline(__always)
func putchar_unlocked(_ c: UInt8) {
  putchar_unlocked(Int32(c))
}

@inlinable
@inline(__always)
public func putchar_unlocked(_ c: Character) {
  for b in c.unicodeScalars {
    putchar_unlocked(Int32(bitPattern: b.value))
  }
}

@usableFromInline
@inline(__always)
func _fastPrintUTF8(_ s: String) {
  let count = s.utf8.count
  _ = s.withCString { pointer in
    fwrite(pointer, 1, count, stdout)
  }
}
