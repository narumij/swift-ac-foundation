import IOBase

extension BinaryFloatingPoint {
  
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atof.read { .init($0) }
  }
}

extension Float: Numeric {}
extension Double: Numeric {}
