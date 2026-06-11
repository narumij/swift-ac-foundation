import BigInt
import IOReader

extension BigInt: IOStringConversionReadable {
  public static func convert(from: String) -> Self { .init(from)! }
}

#if false
  // 入力の制約がInt.minからInt.maxまでの場合利用可
  extension BigInt: IOIntegerConversionReadable {
    public static func convert(from: Int) -> Self { .init(from) }
  }
#endif
