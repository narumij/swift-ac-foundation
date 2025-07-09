import Foundation

extension String {
  
  @inlinable
  @inline(__always)
  public init<S>(ascii: S) where S: Sequence, S.Element == UInt8 {
    self.init(bytes: ascii, encoding: .ascii)!
  }
  
  @inlinable
  @inline(__always)
  public var asciiValues: [UInt8] {
    compactMap(\.asciiValue)
  }
}
