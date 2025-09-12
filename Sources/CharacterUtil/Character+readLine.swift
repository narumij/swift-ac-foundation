import Foundation
import UInt8Util

@inlinable
public func readLine(strippingNewline: Bool = true) -> [Character]? {
  try? _readLine { start, count in
    [Character].init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      for i in 0..<count {
        (buffer.baseAddress! + i).initialize(to: Character(UnicodeScalar(start[i])))
      }
      initializedCount = count
      if strippingNewline, start[count - 1] == 0x0A {
        initializedCount -= 1
      }
    }
  }
}
