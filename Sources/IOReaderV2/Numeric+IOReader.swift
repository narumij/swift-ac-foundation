import IOBase

public protocol Numeric {
  static func read() throws -> Self
  static func lineIterator() -> LineIterator<Self>
  static func lineIterator(columns: Int) -> AnyIterator<Self>
}

extension Numeric {

  public static var stdin: Self {
    try! .read()
  }
}

public protocol Numeric1D {
  associatedtype Element: Numeric
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Numeric1D {

  public static func stdin() -> Self {
    .init(Element.lineIterator())
  }

  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in try! Element.read() })
  }

  public static func stdin(columns: Int) -> Self {
    .init(Element.lineIterator(columns: columns))
  }
}

public protocol Numeric2D {
  associatedtype Element: Numeric1D
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Numeric2D {

  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin() })
  }

  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array: Numeric1D where Element: Numeric {}
extension Array: Numeric2D where Element: Numeric1D {}

extension Set: Numeric1D where Element: Numeric {}
extension Set: Numeric2D where Element: Numeric1D {}
