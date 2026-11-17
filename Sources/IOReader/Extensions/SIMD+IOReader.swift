import IOBase

extension SIMD where Scalar: Component {

  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    var value = Self()
    var separator: UInt8?
    for i in value.indices {
      let item = try Scalar.read()
      value[i] = item.value
      separator = item.separator
      if i != value.indices.last {
        precondition(!isNilOrAsciiNewLine(separator), "the line ended before the group was complete: read \(item.value), next \(describeByte(separator))")
        _ = __ungetc(separator)
      }
    }
    return (value, separator)
  }
}

extension SIMD2: IOConversion, Component, Numeric where Scalar: Component {}
extension SIMD3: IOConversion, Component, Numeric where Scalar: Component {}
extension SIMD4: IOConversion, Component, Numeric where Scalar: Component {}
