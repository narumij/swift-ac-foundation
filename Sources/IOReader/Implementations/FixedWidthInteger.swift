import Foundation

public protocol IOReadableInteger: SingleReadable, InputElementReadable
where Self: FixedWidthInteger & SignedInteger {}

extension IOReadableInteger {

  /// 指定した基数（2〜16）の数字列を読む。接頭辞は解釈しない。
  @inlinable
  @inline(__always)
  public static func read(radix: Int) throws -> Self {
    valuePreservingSeparator(try _atol<Self>._read(radix: radix))
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try _atol<Self>.read()
  }

  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atol<Self>.read()
  }
}

public protocol IOReadableUnsignedInteger: SingleReadable, InputElementReadable
where Self: FixedWidthInteger & UnsignedInteger {}

extension IOReadableUnsignedInteger {

  /// 指定した基数（2〜16）の数字列を読む。接頭辞は解釈しない。
  @inlinable
  @inline(__always)
  public static func read(radix: Int) throws -> Self {
    valuePreservingSeparator(try _atoul<Self>._read(radix: radix))
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try _atoul<Self>.read()
  }

  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atoul<Self>.read()
  }
}

extension Int: IOReadableInteger {}
extension CInt: IOReadableInteger {}
extension CLongLong: IOReadableInteger {}

extension UInt: IOReadableUnsignedInteger {}
extension CUnsignedInt: IOReadableUnsignedInteger {}
extension CUnsignedLongLong: IOReadableUnsignedInteger {}

@available(macOS 15.0.0, *)
extension Int128: IOReadableInteger {}

@available(macOS 15.0.0, *)
extension UInt128: IOReadableUnsignedInteger {}
