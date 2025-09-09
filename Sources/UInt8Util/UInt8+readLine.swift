import _cxx

public
  enum UInt8UtilError: Swift.Error
{
  case unexpectedEOF
}

public func readLine<T>(_ f: (UnsafePointer<UInt8>, Int) throws -> T) throws -> T {
  var utf8Start: UnsafeMutablePointer<UInt8>?
  let utf8Count = _readLine_stdin(&utf8Start)
  defer {
    _free(utf8Start)
  }
  guard utf8Count > 0, let utf8Start else {
    throw UInt8UtilError.unexpectedEOF
  }
  return try f(utf8Start, utf8Count)
}

public func readLine(strippingNewline: Bool = true) -> [UInt8]? {
  try? readLine { start, count in
    [UInt8].init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      buffer.baseAddress?.initialize(from: start, count: count)
      initializedCount = count
      if strippingNewline, start[count - 1] == 0x0A {
        initializedCount -= 1
      }
    }
  }
}
