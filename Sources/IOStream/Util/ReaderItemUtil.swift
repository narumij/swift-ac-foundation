import _FastIO

// The low-level readers consume their separator; value-only reads leave it for the next operation.
// nil means there is no separator to restore.
@inlinable
@inline(__always)
func valuePreservingSeparator<Value>(_ result: ReaderItem<Value>) -> Value {
  _ = _ungetc(result.separator)
  return result.value
}
