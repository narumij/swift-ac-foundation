import IOUtil

@inlinable
public func readLine(strippingNewline: Bool = true) -> [UInt8]? {
  try? getline { start, count in
    [UInt8](unsafeUninitializedCapacity: count) { buffer, initializedCount in
      buffer.baseAddress?.initialize(from: start, count: count)
      initializedCount = count
      if strippingNewline, start[count - 1] == 0x0A {
        initializedCount -= 1
      }
    }
  }
}
