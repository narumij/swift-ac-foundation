import Foundation

/// Reads an input `element` and reports the separator already consumed.
/// See INPUT_GRAMMAR.md; reporting the separator is an API contract, not grammar.
public protocol InputElementReadable: SingleReadable {

  static func _readWithSeparator() throws -> (value: Self, separator: UInt8)
}

/// Reads an `element-line`, returning the values represented by its elements.
/// Unlike a physical line reader, this requires the normalized line format
/// described in INPUT_GRAMMAR.md (nonempty, with no trailing horizontal space).
public protocol ElementLineReadable {
  associatedtype Element: InputElementReadable
  /// Low-level element-line reader used to compose the public input operations.
  static func _readLine() throws -> Self
}

extension ElementLineReadable {

  @inlinable
  @inline(__always)
  static func __readLine<Element>(
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

// MARK: - ElementLineReadable._readLine()

extension Array: ElementLineReadable where Element: InputElementReadable {

  @inlinable
  @inline(__always)
  public static func _readLine() throws -> Self {
    try __readLine(Element._readWithSeparator)
  }

  #if false // Replaced by stdin(check:) with a default argument.
  @inlinable
  @inline(__always)
  public static func stdin() -> Self {
    try! _readLine()
  }
  #endif
}

extension Set: ElementLineReadable where Element: InputElementReadable {

  @inlinable
  @inline(__always)
  public static func _readLine() throws -> Self {
    .init(try __readLine(Element._readWithSeparator))
  }

  #if false // Replaced by stdin(check:) with a default argument.
  @inlinable
  @inline(__always)
  public static func stdin() -> Self {
    try! _readLine()
  }
  #endif
}

extension Array where Element: ElementLineReadable {

  @inlinable
  @inline(__always)
  public static func readLines(count: Int) throws -> Self {
    try (0..<count).map { _ in try Element._readLine() }
  }

  @inlinable
  @inline(__always)
  public static func stdin(rows: Int) -> Self {
    try! readLines(count: rows)
  }
}
