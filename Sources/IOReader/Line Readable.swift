import Foundation
import _FastIO

public protocol LineReadableElement: SingleReadable {

  static func _readWithSeparator() throws -> (value: Self, separator: UInt8)
}

public protocol LineReadable {
  associatedtype Element: LineReadableElement
  static func readLine() throws -> Self
}

// MARK: - LineReadable.readLine()

extension Array: LineReadable where Element: LineReadableElement {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> Self {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin() -> Self {
    try! readLine()
  }
}

extension Set: LineReadable where Element: LineReadableElement {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> Self {
    .init(try readLine(Element._readWithSeparator))
  }

  @inlinable
  @inline(__always)
  public static func stdin() -> Self {
    try! readLine()
  }
}

extension Array where Element: LineReadable {

  @inlinable
  @inline(__always)
  public static func readLines(count: Int) throws -> Self {
    try (0..<count).map { _ in try Element.readLine() }
  }

  @inlinable
  @inline(__always)
  public static func stdin(rows: Int) -> Self {
    try! readLines(count: rows)
  }
}

// MARK: -

extension Array where Element == String {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine_words() throws -> [String] {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin_words() -> [String] {
    try! readLine_words()
  }
}

extension Array where Element == [Character] {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine_words() throws -> [[Character]] {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin_words() -> [[Character]] {
    try! readLine_words()
  }
}

extension Array where Element == [UInt8] {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine_words() throws -> [[UInt8]] {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin_words() -> [[UInt8]] {
    try! readLine_words()
  }
}

// MARK: - Swift.readLine(...)

extension Collection where Element == Character {

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

extension Collection where Element == UInt8 {

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

// MARK: - Implementation

extension Collection {

  @inlinable
  @inline(__always)
  static func readLine(
    _ readWithSeparator: () throws -> (value: Element, separator: UInt8)
  ) throws -> [Element] {
    var result = [Element]()
    while true {
      let (element, separator) = try readWithSeparator()
      result.append(element)
      if isASCIINewlineOrNull(separator) {
        break
      }
    }
    return result
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
