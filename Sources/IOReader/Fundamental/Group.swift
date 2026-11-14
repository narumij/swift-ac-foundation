import IOBase

// グループのコンポーネント。それ以上の意味がまだない
public protocol Component {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}

public protocol Group {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}

extension Group {

  @inlinable
  public static var stdin: Self {
    valuePreservingSeparator(try! _readWithSeparator())
  }

  @inlinable
  static func groups(count: Int) -> AnyIterator<Self> {
    var count = count
    return .init {
      guard count > 0 else { return nil }
      count -= 1
      let (value, separator) = try! _readWithSeparator()
      precondition(
        isNilOrAsciiNewLine(separator),
        "each row must hold exactly one group: read \(value), next \(describeByte(separator))")
      return value
    }
  }
}

public protocol Groups {
  associatedtype Element: Group
  init<S>(_ sequence: S) where S: Sequence, S.Element == Element
}

extension Groups {
  @inlinable
  public static func stdin(rows: Int) -> Self {
    .init(Element.groups(count: rows))
  }
}

extension Array: Groups where Element: Group {}
extension Set: Groups where Element: Group {}
