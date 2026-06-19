import IOUtil

@inlinable
public func readLine(strippingNewline: Bool = true) -> [Character]? {
  try? withUnsafeReadLineBytes { line in
    [Character](unsafeUninitializedCapacity: line.count) { buffer, initializedCount in
      for i in 0..<line.count {
        (buffer.baseAddress! + i).initialize(to: Character(UnicodeScalar(line[i])))
      }
      initializedCount = line.count
      if strippingNewline, line[line.count - 1] == 0x0A {
        initializedCount -= 1
      }
    }
  }
}
