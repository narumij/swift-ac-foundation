import IOBase

extension SIMD where Scalar: Component {

  @inlinable
  public static var columns: Int { Self().scalarCount }

  @inlinable
  public static func read(_ elements: ColumnsIterator<Scalar>) -> Self {
    .init(elements)
  }
}

extension SIMD2: IOFixedArrayConversion, Group where Scalar: Component {}
extension SIMD3: IOFixedArrayConversion, Group where Scalar: Component {}
extension SIMD4: IOFixedArrayConversion, Group where Scalar: Component {}
