
protocol WordCharacter {}

protocol Word {
  associatedtype Element: WordCharacter
}

extension Word {

  static var stdin: Self {
    fatalError()
  }
}

protocol Word1D {
  associatedtype Element: Word
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word1D {
  
  public static func stdin() -> Self {
    fatalError()
  }
  
  public static func stdin(columns: Int) -> Self {
    fatalError()
  }
}

protocol Word2D {
  associatedtype Element: Word1D
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Word2D {
  
  static func stdin(rows: Int) -> Self {
    fatalError()
  }

  static func stdin(rows: Int, columns: Int) -> Self {
    fatalError()
  }
}

// MARK: -

protocol LineCharacter {}

protocol Line {
  associatedtype Element: LineCharacter
}

extension Line {

  static func readLine() -> Self {
    fatalError()
  }
  
  public static func stdin(columns: Int) -> Self {
    fatalError()
  }
}

protocol Line2D {
  associatedtype Element: Line
}

extension Line2D {
  
  static func stdin(rows: Int) -> [String] {
    fatalError()
  }

  static func stdin(rows: Int, columns: Int) -> [String] {
    fatalError()
  }
}
