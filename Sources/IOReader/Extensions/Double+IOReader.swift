import IOBase

extension BinaryFloatingPoint {
  
  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    try _atof.read { .init($0) }
  }
}

extension Float: Numeric {}
extension Double: Numeric {}
