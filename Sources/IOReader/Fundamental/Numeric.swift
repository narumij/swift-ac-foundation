import IOBase

public protocol Numeric: Component {
  static func read() throws -> (value: Self, separator: UInt8?)
  static func lineIterator() -> LineIterator<Self>
  static func lineIterator(columns: Int) -> ColumnsIterator<Self>
}

extension Numeric {

  @inlinable
  public static var stdin: Self {
    _takeValue(try! read())
  }

  @inlinable
  public static func lineIterator() -> LineIterator<Self> {
    .init { try read() }
  }

  @inlinable
  public static func lineIterator(columns: Int) -> ColumnsIterator<Self> {
    .init(columns: columns) { try read() }
  }
}

public protocol Numeric1D: ~Copyable {
  associatedtype Element: Numeric
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Numeric1D where Self: ~Copyable {

  @inlinable
  public static func stdin() -> Self {
    .init(Element.lineIterator())
  }

  @inlinable
  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in
      let (value, separator) = try! Element.read()
      precondition(isNilOrAsciiNewLine(separator), "each row must hold exactly one value: read \(value), next \(describeByte(separator))")
      return value
    })
  }

  @inlinable
  public static func stdin(columns: Int) -> Self {
    .init(Element.lineIterator(columns: columns))
  }
}

public protocol Numeric2D: ~Copyable {
  associatedtype Element: Numeric1D
  init<S: Sequence>(_ sequence: S) where S.Element == Element
}

extension Numeric2D where Self: ~Copyable {

  @inlinable
  public static func stdin(rows: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin() })
  }

  @inlinable
  public static func stdin(rows: Int, columns: Int) -> Self {
    .init((0..<rows).map { _ in Element.stdin(columns: columns) })
  }
}

extension Array: Numeric1D where Element: Numeric {}
extension Array: Numeric2D where Element: Numeric1D {}

extension Set: Numeric1D where Element: Numeric {}
extension Set: Numeric2D where Element: Numeric1D {}
