import IOReader

extension SIMD2 where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read())
  }
}

extension SIMD3 where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}

extension SIMD4 where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}
