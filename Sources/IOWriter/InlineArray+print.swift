import _FastIO

public protocol PrintableInlineArray {
  func print(separator: String, terminator: String)
}

@available(macOS 26.0, *)
extension InlineArray: PrintableInlineArray {

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
extension InlineArray where Element: PrintableInlineArray {

  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    for i in 0..<count {
      self[i].print(separator: separator, terminator: terminator)
    }
  }
}

extension Sequence where Element: PrintableInlineArray {

  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    forEach {
      $0.print(separator: separator, terminator: terminator)
    }
  }
}
