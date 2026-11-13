import IOBase

public protocol WordCharacter {
  static func readWord() throws -> [Self]
  static func wordIterator() -> LineIterator<[Self]>
  static func wordIterator(columns: Int) -> LineIterator<[Self]>
}

public protocol Word {
  associatedtype Element: WordCharacter
  static func read() throws -> Self
  static func wordIterator() -> LineIterator<Self>
  static func wordIterator(columns: Int) -> LineIterator<Self>
}

extension Word {

  public static var stdin: Self {
    try! .read()
  }
}

public protocol Word1D {
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

// MARK: -

public protocol LineCharacter {
  static func characterIterator() -> CharacterIterator<Self>
  static func characterIterator(columns: Int) -> CharacterIterator<Self>
}

public protocol Line {
  associatedtype Element: LineCharacter
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Line {

  public static func readLine() -> Self {
    .init(Element.characterIterator())
  }
  
  public static func stdin(columns: Int) -> Self {
    .init(Element.characterIterator(columns: columns))
  }
}

public protocol Line2D {
  associatedtype Element: Line
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Line2D {
  
  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.readLine() })
  }

  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

// MARK: -

extension UInt8: WordCharacter {
  public static func readWord() throws -> [UInt8] { try _atob.read() }
  public static func wordIterator() -> LineIterator<[UInt8]> { makeLineIterator(_atob.read) }
  public static func wordIterator(columns: Int) -> LineIterator<[UInt8]> {
    makeLineIterator(columns: columns, _atob.read)
  }
}

extension Character: WordCharacter {
  public static func readWord() throws -> [Character] { try _atoc.read() }
  public static func wordIterator() -> LineIterator<[Character]> { makeLineIterator(_atoc.read) }
  public static func wordIterator(columns: Int) -> LineIterator<[Character]> {
    makeLineIterator(columns: columns, _atoc.read)
  }
}

extension Array: Word where Element: WordCharacter {
  public static func read() throws -> Self { try Element.readWord() }
  public static func wordIterator() -> LineIterator<Self> { Element.wordIterator() }
  public static func wordIterator(columns: Int) -> LineIterator<Self> { Element.wordIterator(columns: columns) }
}

extension Array: Word1D where Element: Word {}
extension Array: Word2D where Element: Word1D {}

extension UInt8: LineCharacter {
  public static func characterIterator() -> CharacterIterator<UInt8> { makeCharacterIterator { $0 } }
  public static func characterIterator(columns: Int) -> CharacterIterator<UInt8> {
    makeCharacterIterator(columns: columns) { $0 }
  }
}

extension Character: LineCharacter {
  public static func characterIterator() -> CharacterIterator<Character> {
    makeCharacterIterator { Character(UnicodeScalar($0)) }
  }
  public static func characterIterator(columns: Int) -> CharacterIterator<Character> {
    makeCharacterIterator(columns: columns) { Character(UnicodeScalar($0)) }
  }
}

extension Array: Line where Element: LineCharacter {}
extension Array: Line2D where Element: Line {}
