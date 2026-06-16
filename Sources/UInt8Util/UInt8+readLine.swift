import IOUtil

@inlinable
public func readLine(strippingNewline: Bool = true) -> [UInt8]? {
  try? withUnsafeReadLineBytes { line in
    [UInt8](unsafeUninitializedCapacity: line.count) { buffer, initializedCount in
      buffer.baseAddress?.initialize(from: line.baseAddress!, count: line.count)
      initializedCount = line.count
      if strippingNewline {
        if initializedCount > 0, line[initializedCount - 1] == 0x0A {
          initializedCount -= 1
        }
        if initializedCount > 0, line[initializedCount - 1] == 0x0D {
          initializedCount -= 1
        }
      }
    }
  }
}
