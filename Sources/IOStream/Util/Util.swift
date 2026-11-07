import _FastIO

// The low-level readers consume their separator; value-only reads leave it for the next operation.
// NULL is the existing EOF sentinel. NUL input is outside the supported input grammar.
@inlinable
@inline(__always)
func valuePreservingSeparator<Value>(_ result: (value: Value, separator: UInt8)) -> Value {
  if result.separator != .NULL {
    _ = _ungetc(Int32(result.separator))
  }
  return result.value
}

extension Optional {
  @inlinable @inline(__always)
  package func unwrap(or error: @autoclosure () -> IOReaderError) throws -> Wrapped {
    guard let value = self else { throw error() }
    return value
  }
}
