import IOBase
import IOUtil

protocol WordCharacter {
  static func read() throws -> [Self]
  static func wordIterator() -> LineIterator<[Self]>
  static func wordIterator(columns: Int) -> AnyIterator<[Self]>
}

protocol Word {
  associatedtype Element: WordCharacter
  static func wordIterator() -> LineIterator<Self>
  static func wordIterator(columns: Int) -> AnyIterator<Self>
}

extension Sequence where Element: WordCharacter {

  static var stdin: [Element] {
    try! Element.read()
  }
  
  static func wordIterator() -> LineIterator<[Element]> {
    Element.wordIterator()
  }
  
  static func wordIterator(columns: Int) -> AnyIterator<[Element]> {
    Element.wordIterator(columns: columns)
  }
}

extension Array: Word where Element: WordCharacter { }

protocol Word1D: Sequence where Element: Word {
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

extension Array: Word2D where Element: Word1D {}

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

// MARK: -

extension Character: WordCharacter {
  
  static func read() throws -> [Character] {
    try _atoc.instance.read()
  }
  
  static func wordIterator() -> IOBase.LineIterator<[Character]> {
    makeLineIterator { try! _atoc.instance.read() }
  }
  
  static func wordIterator(columns: Int) -> AnyIterator<[Character]> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atoc.instance.read() : nil
    }
  }
}

// MARK: -

extension Character {
  
  public static var stdin: Self {
    try! _atoc.read(count: 1).first!
  }
}

extension Character: LineCharacter {

  public static func readLine() -> [Character] {
    try! withUnsafeReadLineBytes(strippingNewline: true) { $0.map { Character(UnicodeScalar($0)) } }
  }
  
  public static func readLine(columns: Int) -> [Character] {
    try! _atoc.read(count: columns)
  }
}
