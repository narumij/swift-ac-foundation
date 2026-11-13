import AtCoder

extension static_modint: IOIntegerConversionReadable {
  @inlinable
  public static func convert(from: Int) -> Self { .init(from) }
}

extension dynamic_modint: IOIntegerConversionReadable {
  @inlinable
  public static func convert(from: Int) -> Self { .init(from) }
}
