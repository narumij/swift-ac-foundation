import _FastIO

@available(macOS 26.0, *)
extension InlineArray where Element: FastPrintableInteger & SignedInteger {

  @inlinable
  public func fastPrint(separator: String = "", terminator: String = "\n") {
    for i in 0..<count {
      ___print_int(Int64(self[i]))
      print(i == count - 1 ? terminator : separator, terminator: "")
    }
  }
}

@available(macOS 26.0, *)
extension InlineArray where Element: FastPrintableInteger & UnsignedInteger {

  @inlinable
  public func fastPrint(separator: String = "", terminator: String = "\n") {
    for i in 0..<count {
      ___print_uint(UInt64(self[i]))
      print(i == count - 1 ? terminator : separator, terminator: "")
    }
  }
}
