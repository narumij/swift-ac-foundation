import Foundation

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
}

extension Collection where Element == [Character] {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> [Element] {
    try readLine(Element._readWithSeparator)
  }
}

extension Collection where Element == [UInt8] {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> [Element] {
    try readLine(Element._readWithSeparator)
  }
}

// MARK: - Swift.readLine(...)

extension Collection where Element == Character {

  @inlinable
  @inline(__always)
  public static func readLine(strippingNewline: Bool = true) -> [Element]? {
    Swift.readLine(strippingNewline: strippingNewline)?.map { $0 }
  }
}

extension Collection where Element == UInt8 {

  @inlinable
  @inline(__always)
  public static func readLine(strippingNewline: Bool = true) -> [Element]? {
    Swift.readLine(strippingNewline: strippingNewline)?.compactMap { $0.asciiValue }
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
