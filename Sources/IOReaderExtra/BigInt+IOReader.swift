import BigInt

extension BigInt: IOStringConversionReadable {
  @inlinable
  public static func convert(from: String) -> Self { .init(from)! }
}
