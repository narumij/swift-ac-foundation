import Foundation

extension Int: SingleReadable & ArrayReadable & LineReadable {
  
  // 主力なのでキャストが削れる直接実装に変更
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try _atol.read()
  }
  
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try _atol.read()
  }
}

extension CInt: IOReadableInteger {}
extension CUnsignedInt: IOReadableInteger {}
extension CLongLong: IOReadableInteger {}
extension CUnsignedLongLong: IOReadableInteger {}

// UIntは、IntベースだとUInt.maxが扱えず、Stringベースだと遅いので、ユーザーに委ねることに
//extension UInt: ArrayReadable & LineReadable & _atol_read_impl {}

extension FixedWidthInteger {
  // _readWithSeparator()を一律で生やしてしまうと、
  // Int128やUIntが文字列ベースを選択できなくなるので廃止
  // _atol_read_implを付与する方式に変更
}

public protocol IOReadableInteger: IOIntegerConversionReadable
where Self: FixedWidthInteger { }

extension IOReadableInteger {
  @inlinable
  @inline(__always)
  public static func convert(from: Int) -> Self {
    Self(from)
  }
}

