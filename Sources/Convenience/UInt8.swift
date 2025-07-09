import Foundation

extension Sequence where Element == UInt8 {

  @inlinable
  @inline(__always)
  public func joined() -> String {
    String(bytes: self, encoding: .ascii)!
  }
}
