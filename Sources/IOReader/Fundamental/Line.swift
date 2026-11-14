public protocol LineCharacter {
  static func readLine() -> [Self]
  static func readLine(columns: Int) -> [Self]
}

protocol Line {
  associatedtype Element: LineCharacter
  static func readLine() -> [Element]
  static func stdin(columns: Int) -> [Element]
}

extension Array: Line where Element: LineCharacter {

  @inlinable
  public static func readLine() -> [Element] {
    Element.readLine()
  }

  @inlinable
  public static func stdin(columns: Int) -> [Element] {
    Element.readLine(columns: columns)
  }
}

extension Array where Element == [Character] {

  @inlinable
  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }

  @inlinable
  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array where Element == [UInt8] {

  @inlinable
  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }

  @inlinable
  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}
