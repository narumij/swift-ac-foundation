import _FastIO

extension Array where Element == String {

  public static func stdin(rows: Int, strippingNewline: Bool = true) -> Self {
    (0..<rows).compactMap { _ in Swift.readLine(strippingNewline: strippingNewline) }
  }
}

extension Array where Element == Character {

  @inlinable
  @inline(__always)
  public static func readLine(strippingNewline: Bool = true) -> [Character]? {
    #if true
      return try? __withUnsafeReadLineBytes(strippingNewline: strippingNewline) { readBuffer in
        return [Character](unsafeUninitializedCapacity: readBuffer.count) {
          buffer, initializedCount in
          initializedCount = readBuffer.count
          for i in 0..<readBuffer.count {
            buffer.initializeElement(at: i, to: Character(UnicodeScalar(readBuffer[i])))
          }
        }
      }
    #else
      Swift.readLine(strippingNewline: strippingNewline)?.map { $0 }
    #endif
  }
}

extension Array where Element == [Character] {

  public static func stdin(rows: Int, strippingNewline: Bool = true) -> Self {
    (0..<rows).compactMap { _ in .readLine(strippingNewline: strippingNewline) }
  }
}

extension Array where Element == UInt8 {

  @inlinable
  @inline(__always)
  public static func readLine(strippingNewline: Bool = true) -> [UInt8]? {
    #if true
      return try? __withUnsafeReadLineBytes(strippingNewline: strippingNewline) { readBuffer in
        return [UInt8](unsafeUninitializedCapacity: readBuffer.count) { buffer, initializedCount in
          initializedCount = readBuffer.count
          buffer.baseAddress?.initialize(from: readBuffer.baseAddress!, count: readBuffer.count)
        }
      }
    #else
      Swift.readLine(strippingNewline: strippingNewline)?.compactMap { $0.asciiValue }
    #endif
  }
}

extension Array where Element == [UInt8] {

  public static func stdin(rows: Int, strippingNewline: Bool = true) -> Self {
    (0..<rows).compactMap { _ in .readLine(strippingNewline: strippingNewline) }
  }
}

// MARK: -

@inlinable
@inline(__always)
func __withUnsafeReadLineBytes<T>(
  strippingNewline: Bool = false,
  _ body: (UnsafeBufferPointer<UInt8>) throws -> T
) throws -> T {
  var utf8Start: UnsafeMutablePointer<UInt8>?
  var utf8Count = _readLine_stdin(&utf8Start)
  defer {
    _free(utf8Start)
  }
  guard utf8Count > 0, let utf8Start else {
    throw IOReaderError.unexpectedEmpty
  }
  if strippingNewline, utf8Count > 0, utf8Start[utf8Count - 1] == .LF {
    utf8Count -= 1
  }
  if strippingNewline, utf8Count > 0, utf8Start[utf8Count - 1] == .CR {
    utf8Count -= 1
  }
  return try body(.init(start: utf8Start, count: utf8Count))
}
