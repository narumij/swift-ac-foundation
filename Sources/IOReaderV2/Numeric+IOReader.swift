import IOBase

protocol Numeric {
  static func read() throws -> Self
  static func lineIterator() -> LineIterator<Self>
  static func lineIterator(columns: Int) -> LineIterator<Self>
}

extension Numeric {

  static var stdin: Self {
    try! .read()
  }
}

protocol Numeric1D {
  associatedtype Element: Numeric
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Numeric1D {

  static func stdin() -> Self {
    .init(Element.lineIterator())
  }

  static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in try! Element.read() })
  }

  static func stdin(columns: Int) -> Self {
    .init(Element.lineIterator(columns: columns))
  }
}

protocol Numeric2D {
  associatedtype Element: Numeric1D
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Numeric2D {

  static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin() })
  }

  static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array: Numeric1D where Element: Numeric {}
extension Array: Numeric2D where Element: Numeric1D {}
