import IOBase

public protocol WordCharacter {
  static func read() throws -> [Self]
  static func wordIterator() -> LineIterator<[Self]>
  static func wordIterator(columns: Int) -> AnyIterator<[Self]>
}

public protocol Word {
  associatedtype Element: WordCharacter
  static func wordIterator() -> LineIterator<Self>
  static func wordIterator(columns: Int) -> AnyIterator<Self>
}

extension Sequence where Element: WordCharacter {

  public static var stdin: [Element] {
    try! Element.read()
  }

  public static func wordIterator() -> LineIterator<[Element]> {
    Element.wordIterator()
  }

  public static func wordIterator(columns: Int) -> AnyIterator<[Element]> {
    Element.wordIterator(columns: columns)
  }
}

extension Array: Word where Element: WordCharacter {}

public protocol Word1D: Sequence where Element: Word {
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word1D {

  public static func stdin() -> Self {
    .init(Element.wordIterator())
  }

  public static func stdin(columns: Int) -> Self {
    .init(Element.wordIterator(columns: columns))
  }
}

extension Array: Word1D where Element: Word {}
extension Set: Word1D where Element: Word { }

public protocol Word2D {
  associatedtype Element: Word1D
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word2D {

  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin() })
  }

  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array: Word2D where Element: Word1D {}
extension Set: Word2D where Element: Word1D { }

// MARK: -

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

  public static func readLine() -> [Element] {
    Element.readLine()
  }

  public static func stdin(columns: Int) -> [Element] {
    Element.readLine(columns: columns)
  }
}

extension Array where Element == [Character] {

  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }

  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array where Element == [UInt8] {

  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }

  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}
