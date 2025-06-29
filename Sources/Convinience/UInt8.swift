import Foundation

extension Sequence where Element == UInt8 {

  @inlinable
  public func joined() -> String {
    String(bytes: self, encoding: .ascii)!
  }
}
