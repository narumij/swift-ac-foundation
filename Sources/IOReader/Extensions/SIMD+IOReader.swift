extension SIMD where Scalar: Component {

  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    var value = Self()
    var separator: UInt8?
    for i in value.indices {
      value[i] = try _readGroupElement(last: i == value.indices.last, separator: &separator)
    }
    return (value, separator)
  }
}

extension SIMD2: IOConversion, Component, Numeric where Scalar: Component {}
extension SIMD3: IOConversion, Component, Numeric where Scalar: Component {}
extension SIMD4: IOConversion, Component, Numeric where Scalar: Component {}
