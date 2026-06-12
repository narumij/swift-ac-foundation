import _FastIO

@available(macOS 26.0, *)
extension InlineArray {

  // IOUtilへの配置が妥当かもしれない

  /// 空白区切りで標準出力へ出力する
  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    for i in 0..<endIndex {
      if i != 0 {
        Swift.print(terminator: separator)
      }
      Swift.print(self[i], terminator: "")
    }
    Swift.print(terminator: terminator)
  }
}

@available(macOS 26.0, *)
extension InlineArray where Element: FastPrintableInteger & SignedInteger {

  @inlinable
  public func fastPrint(separator: Int32 = 0x20, terminator: Int32 = 0x0A) {
    for i in 0..<count {
      ___print_int(Int64(self[i]))
      putchar_unlocked(i == count - 1 ? terminator : separator)
    }
  }
}

@available(macOS 26.0, *)
extension InlineArray where Element: FastPrintableInteger & UnsignedInteger {

  @inlinable
  public func fastPrint(separator: Int32 = 0x20, terminator: Int32 = 0x0A) {
    for i in 0..<count {
      ___print_uint(UInt64(self[i]))
      putchar_unlocked(i == count - 1 ? terminator : separator)
    }
  }
}
