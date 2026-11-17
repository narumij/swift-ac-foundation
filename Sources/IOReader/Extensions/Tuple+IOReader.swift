import IOBase

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func stdin<each T: Component>() -> (repeat each T) {
  valuePreservingSeparator(try! _readGroupElements())
}

// MARK: -

@inlinable
package func _readGroupElement<T: Component>(last: Bool, separator: inout UInt8?) throws -> T {
  let item = try T._readWithSeparator()
  if !last { precondition(!isNilOrAsciiNewLine(item.separator), "the line ended before the group was complete: read \(item.value), next \(describeByte(item.separator))") }
  separator = item.separator
  if !last { _ = __ungetc(item.separator) }
  return item.value
}

@inlinable
func _readGroupElements<each T: Component>() throws -> (value: (repeat each T), separator: UInt8?) {
  var separator: UInt8?
  var remaining = 0
  for _ in repeat (each T).self { remaining += 1 }
  func read<U: Component>(_: U.Type) throws -> U {
    remaining -= 1
    return try _readGroupElement(last: remaining == 0, separator: &separator)
  }
  let value = (repeat try read((each T).self))
  return (value, separator)
}

@inlinable
func _readGroupElements<each T: Component, S>(
  _ f: ((repeat each T)) -> S
) throws -> (value: S, separator: UInt8?) {
  let (value, separator): ((repeat each T), UInt8?) = try _readGroupElements()
  return (f((repeat each value)), separator)
}
