import Foundation

extension Sequence where Element == UInt8 {
  
  @inlinable
  func putchars_unlocked(terminator: Int32? = 0x0A) {
    forEach {
      putchar_unlocked(Int32($0))
    }
    if let terminator {
      putchar_unlocked(terminator)
    }
  }
}
