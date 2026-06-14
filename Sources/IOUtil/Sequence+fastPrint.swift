import Foundation

extension Sequence where Element: FastPrintableInteger & SignedInteger {

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    var first = true
    for element in self {
      if first {
        first = false
      } else {
        print(separator, terminator: "")
      }
      IOUtil.fastPrint(element, terminator: nil)
    }
    if !first {
      print(terminator: terminator)
    }
  }
}

extension Sequence where Element: FastPrintableInteger & UnsignedInteger {

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    var first = true
    for element in self {
      if first {
        first = false
      } else {
        print(separator, terminator: "")
      }
      IOUtil.fastPrint(element, terminator: nil)
    }
    if !first {
      print(terminator: terminator)
    }
  }
}
