import Foundation

extension String {
  
  @inlinable
  init<S>(ascii: S) where S: Sequence, S.Element == UInt8 {
    self.init(bytes: ascii, encoding: .ascii)!
  }
  
  @inlinable
  var asciiValues: [UInt8] {
    compactMap(\.asciiValue)
  }
}
