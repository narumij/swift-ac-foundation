import IOBase

extension FixedWidthInteger where Self: UnsignedInteger {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atoul<Self>.read()
  }
}

extension UInt: Numeric {}
extension UInt64: Numeric {}
extension UInt32: Numeric {}
extension UInt16: Numeric {}

@available(macOS 15.0, *)
extension UInt128: Numeric {}
