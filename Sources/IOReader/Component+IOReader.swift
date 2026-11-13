import Pack
import IOBase

public protocol Component {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}

public protocol Group {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}

extension Group {

  public static var stdin: Self {
    valuePreservingSeparator(try! _readWithSeparator())
  }

  static func groups(count: Int) -> AnyIterator<Self> {
    var count = count
    return .init {
      guard count > 0 else { return nil }
      count -= 1
      let (value, separator) = try! _readWithSeparator()
      precondition(isNilOrAsciiNewLine(separator), "each row must hold exactly one group")
      return value
    }
  }
}

public protocol Groups {
  associatedtype Element: Group
  init<S>(_ sequence: S) where S: Sequence, S.Element == Element
}

extension Groups {
  public static func stdin(rows: Int) -> Self {
    .init(Element.groups(count: rows))
  }
}

extension Array: Groups where Element: Group {}
extension Set: Groups where Element: Group {}

// MARK: -

extension SIMD where Scalar: Component {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    var v = Self()
    for i in v.indices {
      let item = try Scalar._readWithSeparator()
      if i < v.scalarCount - 1 { precondition(!isNilOrAsciiNewLine(item.separator), "the line ended before the group was complete") }
      v[i] = valuePreservingSeparator(item)
    }
    return (v, __getchar_unlocked())
  }
}

extension SIMD2: Group where Scalar: Component { }
extension SIMD3: Group where Scalar: Component { }
extension SIMD4: Group where Scalar: Component { }

@available(macOS 14.0.0, *)
extension Pack: Group where repeat each T: Component {
  
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    var started = false
    var previous: UInt8?
    func read<U: Component>(_: U.Type) throws -> U {
      if started { precondition(!isNilOrAsciiNewLine(previous), "the line ended before the group was complete") }
      started = true
      let item = try U._readWithSeparator()
      previous = item.separator
      return valuePreservingSeparator(item)
    }
    return (.init(repeat try read((each T).self)), __getchar_unlocked())
  }
}

@available(macOS 26.0, *)
extension InlineArray: Group where Element: Component {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    let value = try Self { i in
      let (value, separator) = try Element._readWithSeparator()
      if i < count - 1 { precondition(!isNilOrAsciiNewLine(separator), "the line ended before the group was complete") }
      return valuePreservingSeparator((value, separator))
    }
    return (value, __getchar_unlocked())
  }
}

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func stdin<each T: Component>() -> (repeat each T) {
  (repeat valuePreservingSeparator(try! (each T)._readWithSeparator()))
}
