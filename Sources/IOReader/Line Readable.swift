import Foundation
import _FastIO

public protocol LineReadable: SingleReadable {

  static func _readWithSeparator() throws -> (value: Self, separator: UInt8)
}

// MARK: - LineReadable.readLine()

extension Collection where Element: LineReadable {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> [Element] {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin() -> [Element] {
    try! readLine()
  }
}

extension Collection where Element == [Character] {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine() throws -> [[Character]] {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin() -> [[Character]] {
    try! readLine()
  }
}

extension Collection where Element == [UInt8] {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine() throws -> [[UInt8]] {
    try readLine(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin() -> [[UInt8]] {
    try! readLine()
  }
}

extension Collection where Element: Collection, Element.Element: LineReadable {

  @inlinable
  @inline(__always)
  public static func readLine(rows: Int) throws -> [[Element.Element]] {
    try (0..<rows).map { _ in try [Element.Element].readLine() }
  }

  @inlinable
  @inline(__always)
  public static func stdin(rows: Int) -> [[Element.Element]] {
    try! readLine(rows: rows)
  }
}

// MARK: - Swift.readLine(...)

extension Collection where Element == Character {

  @inlinable
  @inline(__always)
  public static func readLine(strippingNewline: Bool = true) -> [Character]? {
    #if true
      var utf8Start: UnsafeMutablePointer<UInt8>?
      let utf8Count = _readLine_stdin(&utf8Start)
      defer {
        _free(utf8Start)
      }
      guard utf8Count > 0, let utf8Start else {
        return nil
      }
      var count = utf8Count
      if strippingNewline {
        if count > 0, utf8Start[count - 1] == .LF {
          count -= 1
        }
        if count > 0, utf8Start[count - 1] == .CR {
          count -= 1
        }
      }
      let result = [Character].init(unsafeUninitializedCapacity: count) {
        buffer, initializedCount in
        initializedCount = count
        for i in 0..<count {
          buffer.initializeElement(at: i, to: Character(UnicodeScalar(utf8Start[i])))
        }
      }
      return result
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
      var utf8Start: UnsafeMutablePointer<UInt8>?
      let utf8Count = _readLine_stdin(&utf8Start)
      defer {
        _free(utf8Start)
      }
      guard utf8Count > 0, let utf8Start else {
        return nil
      }
      var count = utf8Count
      if strippingNewline {
        if count > 0, utf8Start[count - 1] == .LF {
          count -= 1
        }
        if count > 0, utf8Start[count - 1] == .CR {
          count -= 1
        }
      }
      let result = [UInt8].init(unsafeUninitializedCapacity: count) {
        buffer, initializedCount in
        initializedCount = count
        buffer.baseAddress?.initialize(from: utf8Start, count: count)
      }
      return result
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
