import IOUtil

@inlinable
public func readLine(strippingNewline: Bool = true) -> [Character]? {
  try? getline { start, count in
    [Character](unsafeUninitializedCapacity: count) { buffer, initializedCount in
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
