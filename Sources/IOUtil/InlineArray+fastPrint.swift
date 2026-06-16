import _FastIO

public protocol SignedIntegerInlineArray {
  associatedtype Element: SignedInteger
  func fastPrint(separator: String, terminator: String)
}

public protocol UnsignedIntegerInlineArray {
  associatedtype Element: UnsignedInteger
  func fastPrint(separator: String, terminator: String)
}

@available(macOS 26.0, *)
extension InlineArray: SignedIntegerInlineArray where Element: FastPrintableInteger & SignedInteger {

  @inlinable
  public func fastPrint(separator: String = "", terminator: String = "\n") {
    for i in 0..<count {
      ___print_int(Int64(self[i]))
      print(i == count - 1 ? terminator : separator, terminator: "")
    }
  }
}

@available(macOS 26.0, *)
extension InlineArray: UnsignedIntegerInlineArray where Element: FastPrintableInteger & UnsignedInteger {

  @inlinable
  public func fastPrint(separator: String = "", terminator: String = "\n") {
    for i in 0..<count {
      ___print_uint(UInt64(self[i]))
      print(i == count - 1 ? terminator : separator, terminator: "")
    }
  }
}

@available(macOS 26.0, *)
extension InlineArray where Element: SignedIntegerInlineArray {

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    for i in 0..<count {
      self[i].fastPrint(separator: separator, terminator: terminator)
    }
  }
}

extension Sequence where Element: UnsignedIntegerInlineArray {

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    forEach {
      $0.fastPrint(separator: separator, terminator: terminator)
    }
  }
}
