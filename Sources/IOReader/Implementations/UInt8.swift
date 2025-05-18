import Foundation

extension UInt8: AsciiReadable {}

extension UInt8 {
  
  /// Ascii Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> UInt8 {
    try _atob.read(count: 1).first.unwrap(or: Error.unexpectedNil)
  }
}

extension UInt8: AsciiArrayReadable {}

extension UInt8 {

  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> [UInt8] {
    try _atob.read()
  }
  
  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [UInt8] {
    try _atob.read(count: columns)
  }

  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: [UInt8], separator: UInt8) {
    try _atob.read()
  }
}
