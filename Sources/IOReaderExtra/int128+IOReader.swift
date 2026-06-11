import IOReader

@available(macOS 15.0, *)
extension Int128: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}

@available(macOS 15.0, *)
extension UInt128: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}
