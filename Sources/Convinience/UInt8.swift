import Foundation

extension Sequence where Element == UInt8 {

  @inlinable func joined() -> String {
    String(bytes: self, encoding: .ascii)!
  }
}
