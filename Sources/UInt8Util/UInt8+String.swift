import Foundation

extension String {
  
  @inlinable
  public init<S>(ascii: S) where S: Sequence, S.Element == UInt8 {
    self.init(bytes: ascii, encoding: .ascii)!
  }
  
  @inlinable
  public var asciiValues: [UInt8] {
    compactMap(\.asciiValue)
  }
}
