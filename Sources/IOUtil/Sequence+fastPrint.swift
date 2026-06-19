import Foundation

extension Sequence where Element: FastPrintableInteger & SignedInteger {

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    var first = true
    for element in self {
      if first {
        first = false
      } else {
        _fastPrintUTF8(separator)
      }
      IOUtil.fastPrint(element, terminator: nil)
    }
    if !first {
      _fastPrintUTF8(terminator)
    }
  }
}

extension Sequence
where
  Element: Sequence,
  Element.Element: FastPrintableInteger & SignedInteger
{

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    forEach {
      $0.fastPrint(separator: separator, terminator: terminator)
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
        _fastPrintUTF8(separator)
      }
      IOUtil.fastPrint(element, terminator: nil)
    }
    if !first {
      _fastPrintUTF8(terminator)
    }
  }
}

extension Sequence
where
  Element: Sequence,
  Element.Element: FastPrintableInteger & UnsignedInteger
{

  @inlinable
  public func fastPrint(separator: String = " ", terminator: String = "\n") {
    forEach {
      $0.fastPrint(separator: separator, terminator: terminator)
    }
  }
}
