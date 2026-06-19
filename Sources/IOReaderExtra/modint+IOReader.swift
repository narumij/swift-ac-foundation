import AtCoder
import IOReader

extension static_modint: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}

#if false
  // 入力の制約が0からmod未満までの場合利用可
  extension static_modint: @retroactive IOUnsignedIntegerConversionReadable {
    @inlinable @inline(__always)
    public static func convert(from: UInt) -> Self { .init(rawValue: from) }
  }
#endif

extension dynamic_modint: IOIntegerConversionReadable {
  public static func convert(from: Int) -> Self { .init(from) }
}
