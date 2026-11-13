import IOBase

public protocol Numeric: Component {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
  static func lineIterator() -> LineIterator
  static func lineIterator(columns: Int) -> AnyIterator<Self>
  associatedtype LineIterator: LineIteratorProtocol where LineIterator.Element == Self
}

extension Numeric {

  public static var stdin: Self {
    valuePreservingSeparator(try! _readWithSeparator())
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
    .init((0..<rows).map { _ in Element.stdin })
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
