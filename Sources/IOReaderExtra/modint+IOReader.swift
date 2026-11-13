import AtCoder

extension static_modint: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}

extension dynamic_modint: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
