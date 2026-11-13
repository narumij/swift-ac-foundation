import IOBase

protocol WordCharacter {}

protocol Word {
  associatedtype Element: WordCharacter
  static func read() throws -> Self
  static func lineIterator() -> LineIterator<Self>
  static func lineIterator(columns: Int) -> LineIterator<Self>
}

extension Word {

  static var stdin: Self {
    try! .read()
  }
}

protocol Word1D {
  associatedtype Element: Word
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word1D {
  
  public static func stdin() -> Self {
    .init(Element.lineIterator())
  }
  
  public static func stdin(columns: Int) -> Self {
    .init(Element.lineIterator(columns: columns))
  }
}

protocol Word2D {
  associatedtype Element: Word1D
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word2D {
  
  static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin() })
  }

  static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

// MARK: -

protocol LineCharacter {
  static func lineIterator() -> LineIterator<Self>
  static func lineIterator(columns: Int) -> LineIterator<Self>
}

protocol Line {
  associatedtype Element: LineCharacter
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Line {

  static func readLine() -> Self {
    .init(Element.lineIterator())
  }
  
  public static func stdin(columns: Int) -> Self {
    .init(Element.lineIterator(columns: columns))
  }
}

protocol Line2D {
  associatedtype Element: Line
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Line2D {
  
  static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }

  static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}
