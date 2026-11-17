import IOBase

public protocol WordCharacter {
  static func read() throws -> (value: [Self], separator: UInt8?)
}

public protocol Word {
  associatedtype Element: WordCharacter
  static func read() throws -> (value: Self, separator: UInt8?)
  static func wordIterator() -> LineIterator<Self>
  static func wordIterator(columns: Int) -> ColumnsIterator<Self>
}

extension Word {

  @inlinable
  public static var stdin: Self {
    _takeValue(try! read())
  }

  @inlinable
  public static func wordIterator() -> LineIterator<Self> {
    .init { try read() }
  }

  @inlinable
  public static func wordIterator(columns: Int) -> ColumnsIterator<Self> {
    .init(columns: columns) { try read() }
  }
}

extension Array: Word & Component where Element: WordCharacter {

  @inlinable
  public static func read() throws -> (value: [Element], separator: UInt8?) {
    try Element.read()
  }
}

public protocol Word1D: Sequence where Element: Word {
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word1D {

  @inlinable
  public static func stdin() -> Self {
    .init(Element.wordIterator())
  }

  @inlinable
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

  @inlinable
  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin() })
  }

  @inlinable
  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array: Word2D where Element: Word1D {}
extension Set: Word2D where Element: Word1D { }
