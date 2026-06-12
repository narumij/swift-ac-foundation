extension Collection where Element: FixedWidthInteger & SignedInteger, Index == Int {

  /// 空白区切りで標準出力へ出力する
  @inlinable
  public func fastPrint(separator: Int32 = 0x20, terminator: Int32 = 0x0A) {
    IOUtil.fastPrint(self, separator: separator, terminator: terminator)
  }
}

extension Collection where Element: FixedWidthInteger & UnsignedInteger, Index == Int {

  /// 空白区切りで標準出力へ出力する
  @inlinable
  public func fastPrint(separator: Int32 = 0x20, terminator: Int32 = 0x0A) {
    IOUtil.fastPrint(self, separator: separator, terminator: terminator)
  }
}
