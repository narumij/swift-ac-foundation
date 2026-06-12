
extension Sequence where Element: CustomStringConvertible {
  
  // IOUtilへの配置が妥当かもしれない
  
  /// 空白区切りで標準出力へ出力する
  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    var first = true
    forEach { element in
      if first {
        first = false
      } else {
        Swift.print(separator, terminator: "")
      }
      Swift.print(element.description, terminator: "")
    }
    Swift.print("", terminator: terminator)
  }
}
