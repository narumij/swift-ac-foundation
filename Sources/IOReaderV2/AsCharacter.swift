import IOBase
import IOUtil

protocol WordCharacter {}

protocol Word {
  associatedtype Element: WordCharacter
  static func read() throws -> Self
  static func wordIterator() -> LineIterator<Self>
  static func wordIterator(columns: Int) -> LineIterator<Self>
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
    .init(Element.wordIterator())
  }
  
  public static func stdin(columns: Int) -> Self {
    .init(Element.wordIterator(columns: columns))
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

  static func readLine() -> [Element] {
    Element.readLine()
  }
  
  public static func stdin(columns: Int) -> [Element] {
    Element.readLine(columns: columns)
  }
}

extension Array where Element == [Character] {
  
  static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }
  
  static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

// MARK: -

extension Character: LineCharacter {
  
  static var stdin: Self {
    try! _atoc.read(count: 1).first!
  }
}

extension Array where Element == Character {
  
  static func read() throws -> Self {
    try _atoc.instance.read()
  }
  
  static func wordIterator() -> LineIterator<Self> {
    makeLineIterator { try! _atoc.instance.read() }
  }
  
  static func wordIterator(columns: Int) -> AnyIterator<Self> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atoc.instance.read() : nil
    }
  }
}

extension Character {

  public static func readLine() -> [Character] {
    try! withUnsafeReadLineBytes { $0.map { Character(UnicodeScalar($0)) } }
  }
  
  public static func readLine(columns: Int) -> [Character] {
    try! _atoc.read(count: columns)
  }
}
