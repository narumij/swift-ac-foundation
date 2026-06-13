import IOReader

extension SIMD2: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read())
  }
}

extension SIMD3: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}

extension SIMD4: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try Scalar.read(), try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}

extension SIMD8: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(
      try Scalar.read(), try Scalar.read(), try Scalar.read(), try Scalar.read(),
      try Scalar.read(), try Scalar.read(), try Scalar.read(), try Scalar.read())
  }
}

extension SIMD16: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(lowHalf: try .read(), highHalf: try .read())
  }
}

extension SIMD32: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(lowHalf: try .read(), highHalf: try .read())
  }
}

extension SIMD64: SingleReadable where Scalar: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(lowHalf: try .read(), highHalf: try .read())
  }
}
