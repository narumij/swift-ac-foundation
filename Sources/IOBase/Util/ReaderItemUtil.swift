import _FastIO

// Value-only reads consume a newline; other trailing bytes remain for the next operation.
// nil means there is no separator to restore.
@inlinable
@inline(__always)
package func valuePreservingSeparator<Value>(_ result: ReaderItem<Value>) -> Value {
  if result.separator.map(isASCIINewline) == false {
    _ = __ungetc(result.separator)
  }
  return result.value
}
