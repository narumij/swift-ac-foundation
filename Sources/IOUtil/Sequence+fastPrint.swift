import Foundation

extension Sequence where Element: FastPrintableInteger & SignedInteger {

  @inlinable
  public func fastPrint(separator: Int32 = 0x20, terminator: Int32 = 0x0A) {
    var first = true
    for element in self {
      if first {
        first = false
      } else {
        putchar_unlocked(separator)
      }
      IOUtil.fastPrint(element, terminator: nil)
    }
    if !first {
      putchar_unlocked(terminator)
    }
  }
}

extension Sequence where Element: FastPrintableInteger & UnsignedInteger {

  @inlinable
  public func fastPrint(separator: Int32 = 0x20, terminator: Int32 = 0x0A) {
    var first = true
    for element in self {
      if first {
        first = false
      } else {
        putchar_unlocked(separator)
      }
      IOUtil.fastPrint(element, terminator: nil)
    }
    if !first {
      putchar_unlocked(terminator)
    }
  }
}
