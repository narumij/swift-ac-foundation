import IOBase

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func stdin<each T: Component>() -> (repeat each T) {
  try! _readGroupElements()
}

// MARK: -

@inlinable
package func _readGroupElement<T: Component>(last: Bool) throws -> T {
  let item = try T._readWithSeparator()
  if !last { precondition(!isNilOrAsciiNewLine(item.separator), "the line ended before the group was complete: read \(item.value), next \(describeByte(item.separator))") }
  return valuePreservingSeparator(item)
}

@inlinable
func _readGroupElements<each T: Component>() throws -> (repeat each T) {
  var remaining = 0
  for _ in repeat (each T).self { remaining += 1 }
  func read<U: Component>(_: U.Type) throws -> U {
    remaining -= 1
    return try _readGroupElement(last: remaining == 0)
  }
  return (repeat try read((each T).self))
}
