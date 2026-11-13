import IOReader
import IOBase

public protocol IOConversionReadable: Component & Numeric {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}

public protocol IOIntegerConversionReadable: IOConversionReadable {
  static func convert(from: Int) -> Self
}

public protocol IOUnsignedIntegerConversionReadable: IOConversionReadable {
  static func convert(from: UInt) -> Self
}

public protocol IODoubleConversionReadable: IOConversionReadable {
  static func convert(from: Double) -> Self
}

public protocol IOStringConversionReadable: IOConversionReadable {
  static func convert(from: String) -> Self
}

public protocol IOBytesConversionReadable: IOConversionReadable {
  static func convert(from: [UInt8]) -> Self
}

// MARK: -

extension IOIntegerConversionReadable {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atol.read { convert(from: $0) }
  }
}

extension IOUnsignedIntegerConversionReadable {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atoul.read { convert(from: $0) }
  }
}

extension IODoubleConversionReadable {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atof.read { convert(from: $0) }
  }
}

extension IOStringConversionReadable {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atos.read { convert(from: $0) }
  }
}

extension IOBytesConversionReadable {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atob.read { convert(from: $0) }
  }
}
