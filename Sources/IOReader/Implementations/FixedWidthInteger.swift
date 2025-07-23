import Foundation

extension Int: SingleReadable & ArrayReadable & LineReadable {
  
  // 主力なのでキャストが削れる直接実装に変更
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try __atol<Self>.read()
  }
  
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try __atol<Self>.read()
  }
}

extension UInt: SingleReadable & ArrayReadable & LineReadable {
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try __atoul<Self>.read()
  }
  
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try __atoul<Self>.read()
  }
}

#if true
extension Int128: SingleReadable & ArrayReadable & LineReadable {
  
  // 主力なのでキャストが削れる直接実装に変更
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try __atol<Self>.read()
  }
  
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try __atol<Self>.read()
  }
}

#if true
extension UInt128: SingleReadable & ArrayReadable & LineReadable {
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try __atoul<Self>.read()
  }
  
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try __atoul<Self>.read()
  }
}
#endif
#endif


extension CInt: IOReadableInteger {}
extension CUnsignedInt: IOReadableUnsignedInteger {}
extension CLongLong: IOReadableInteger {}
extension CUnsignedLongLong: IOReadableUnsignedInteger {}

extension FixedWidthInteger {
  // _readWithSeparator()を一律で生やしてしまうと、
  // Int128やUIntが文字列ベースを選択できなくなるので廃止
  // _atol_read_implを付与する方式に変更
}

public protocol IOReadableInteger: IOIntegerConversionReadable
where Self: FixedWidthInteger { }

extension IOReadableInteger {
  @inlinable
  @inline(__always)
  public static func convert(from: Int) -> Self {
    Self(from)
  }
}

public protocol IOReadableUnsignedInteger: IOUnsignedIntegerConversionReadable
where Self: FixedWidthInteger { }

extension IOReadableUnsignedInteger {
  @inlinable
  @inline(__always)
  public static func convert(from: UInt) -> Self {
    Self(from)
  }
}
