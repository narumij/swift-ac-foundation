extension SIMD where Scalar: Component {

  @inlinable
  public static func read() throws -> Self {
    var value = Self()
    for i in value.indices {
      value[i] = try _readGroupElement(last: i == value.indices.last)
    }
    return value
  }
}

extension SIMD2: IOConversion, Component, Numeric where Scalar: Component {}
extension SIMD3: IOConversion, Component, Numeric where Scalar: Component {}
extension SIMD4: IOConversion, Component, Numeric where Scalar: Component {}
