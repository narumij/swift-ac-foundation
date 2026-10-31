import Foundation

public protocol LineReadableElement: SingleReadable {

  static func _readWithSeparator() throws -> (value: Self, separator: UInt8)
}

public protocol LineReadable {
  associatedtype Element: LineReadableElement
  static func readLine() throws -> Self
}

extension LineReadable {

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

// MARK: - LineReadable.readLine()

extension Array: LineReadable where Element: LineReadableElement {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> Self {
    try __readLine(Element._readWithSeparator)
  }

  #if false // Replaced by stdin(check:) with a default argument.
  @inlinable
  @inline(__always)
  public static func stdin() -> Self {
    try! readLine()
  }
  #endif
}

extension Set: LineReadable where Element: LineReadableElement {

  @inlinable
  @inline(__always)
  public static func readLine() throws -> Self {
    .init(try __readLine(Element._readWithSeparator))
  }

  #if false // Replaced by stdin(check:) with a default argument.
  @inlinable
  @inline(__always)
  public static func stdin() -> Self {
    try! readLine()
  }
  #endif
}

extension Array where Element: LineReadable {

  @inlinable
  @inline(__always)
  public static func readLines(count: Int) throws -> Self {
    try (0..<count).map { _ in try Element.readLine() }
  }

  #if false // Replaced by stdin(rows:check:) with a default argument.
  @inlinable
  @inline(__always)
  public static func stdin(rows: Int) -> Self {
    try! readLines(count: rows)
  }
  #endif
}
