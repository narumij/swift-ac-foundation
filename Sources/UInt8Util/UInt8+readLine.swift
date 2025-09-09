import _cxx

#if os(macOS) || os(iOS)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#elseif canImport(Musl)
#else
#endif

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

func __readLine_stdin(_ p: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>) -> Int {
  var capacity = 0
  var result = 0
  repeat {
    result = getline(p, &capacity, stdin)
  } while result < 0 && errno == EINTR
  return result
}

public func __readLine<T>(_ f: (UnsafePointer<CChar>, Int) throws -> T) throws -> T {
  var utf8Start: UnsafeMutablePointer<CChar>?
  let utf8Count = __readLine_stdin(&utf8Start)
  defer {
    _free(utf8Start)
  }
  guard utf8Count > 0, let utf8Start else {
    throw UInt8UtilError.unexpectedEOF
  }
  return try f(utf8Start, utf8Count)
}

public func __readLine(strippingNewline: Bool = true) -> [UInt8]? {
  try? __readLine { start, count in
    [UInt8].init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      for i in 0..<count {
        (buffer.baseAddress! + i).initialize(to: UInt8(start[i]))
      }
      initializedCount = count
      if strippingNewline, start[count - 1] == 0x0A {
        initializedCount -= 1
      }
    }
  }
}
