import IOBase

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func stdin<each T: Component>() -> (repeat each T) {
  _takeValue(try! _readTuple { $0 })
}

// MARK: -

@inlinable
func _readTuple<each T: Component, S>(
  _ f: ((repeat each T)) -> S
) throws -> (value: S, separator: UInt8?) {
  var separator: UInt8?
  var remaining = 0
  for _ in repeat (each T).self { remaining += 1 }
  func read<U: Component>(_: U.Type) throws -> U {
    remaining -= 1
    let item = try U.read()
    separator = item.separator
    if remaining > 0 {
      precondition(!isNilOrAsciiNewLine(separator), "the line ended before the group was complete: read \(item.value), next \(describeByte(separator))")
      _ = __ungetc(separator)
    }
    return item.value
  }
  let value = (repeat try read((each T).self))
  return (f((repeat each value)), separator)
}
