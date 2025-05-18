@preconcurrency import Foundation

public protocol IOIntegerConversionReadable: SingleReadable, ArrayReadable, LineReadable {
  static func convert(from: Int) -> Self
}

public protocol IOFloatingPointConversionReadable: SingleReadable, ArrayReadable, LineReadable {
  static func convert(from: Double) -> Self
}

public protocol IOStringConversionReadable: SingleReadable, ArrayReadable, LineReadable {
  static func convert(from: String) -> Self
}

public protocol IOBytesConversionReadable: SingleReadable, ArrayReadable, LineReadable {
  static func convert(from: [UInt8]) -> Self
}

// MARK: -

extension IOIntegerConversionReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    convert(from: try _atol.read())
  }

  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atol.read { convert(from: $0) }
  }
}

extension IOFloatingPointConversionReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    convert(from: try _atof.read())
  }

  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atof.read { convert(from: $0) }
  }
}

extension IOStringConversionReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    convert(from: try _atos.read())
  }

  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atos.read { convert(from: $0) }
  }
}

extension IOBytesConversionReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    convert(from: try _atob.read())
  }

  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atob.read { convert(from: $0) }
  }
}
