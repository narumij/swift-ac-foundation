import Pack
import IOBase

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
      precondition(isNilOrAsciiNewLine(separator), "each row must hold exactly one group: read \(value), next \(describeByte(separator))")
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

// MARK: -

@inlinable
func _readGroupElement<T: Component>(last: Bool) throws -> T {
  let item = try T._readWithSeparator()
  if !last { precondition(!isNilOrAsciiNewLine(item.separator), "the line ended before the group was complete: read \(item.value), next \(describeByte(item.separator))") }
  return valuePreservingSeparator(item)
}

extension SIMD where Scalar: Component {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    var v = Self()
    for i in v.indices {
      v[i] = try _readGroupElement(last: i == v.scalarCount - 1)
    }
    return (v, __getchar_unlocked())
  }
}

extension SIMD2: Group where Scalar: Component { }
extension SIMD3: Group where Scalar: Component { }
extension SIMD4: Group where Scalar: Component { }

@available(macOS 14.0.0, *)
extension Pack: Group where repeat each T: Component {
  
  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    var remaining = 0
    for _ in repeat (each T).self { remaining += 1 }
    func read<U: Component>(_: U.Type) throws -> U {
      remaining -= 1
      return try _readGroupElement(last: remaining == 0)
    }
    return (.init(repeat try read((each T).self)), __getchar_unlocked())
  }
}

extension Pack2: Group where T: Component, U: Component {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    let first: T = try _readGroupElement(last: false)
    let second: U = try _readGroupElement(last: true)
    return (.init(first, second), __getchar_unlocked())
  }
}

extension Pack3: Group where T: Component, U: Component, V: Component {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    let first: T = try _readGroupElement(last: false)
    let second: U = try _readGroupElement(last: false)
    let third: V = try _readGroupElement(last: true)
    return (.init(first, second, third), __getchar_unlocked())
  }
}

extension Pack4: Group where T: Component, U: Component, V: Component, W: Component {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    let first: T = try _readGroupElement(last: false)
    let second: U = try _readGroupElement(last: false)
    let third: V = try _readGroupElement(last: false)
    let fourth: W = try _readGroupElement(last: true)
    return (.init(first, second, third, fourth), __getchar_unlocked())
  }
}

@available(macOS 26.0, *)
extension InlineArray: Group where Element: Component {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    let value = try Self { i in
      try _readGroupElement(last: i == count - 1)
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
