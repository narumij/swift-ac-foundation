import Foundation

public protocol IOReadableInteger: SingleReadable, ArrayReadable, LineReadable
where Self: FixedWidthInteger & SignedInteger { }

extension IOReadableInteger {
  
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

public protocol IOReadableUnsignedInteger: SingleReadable, ArrayReadable, LineReadable
where Self: FixedWidthInteger & UnsignedInteger { }

extension IOReadableUnsignedInteger {
  
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

extension Int: IOReadableInteger { }
extension UInt: IOReadableUnsignedInteger { }

extension CInt: IOReadableInteger { }
extension CUnsignedInt: IOReadableUnsignedInteger { }
extension CLongLong: IOReadableInteger { }
extension CUnsignedLongLong: IOReadableUnsignedInteger { }

#if false
extension Int128: IOReadableInteger { }
extension UInt128: IOReadableUnsignedInteger { }
#endif
