extension Optional {
  @inlinable @inline(__always)
  package func unwrap(or error: @autoclosure () -> IOReaderError) throws -> Wrapped {
    guard let value = self else { throw error() }
    return value
  }
}
