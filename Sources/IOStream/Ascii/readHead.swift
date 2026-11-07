import _FastIO

extension FixedWidthInteger {

  @inlinable
  @inline(__always)
  static func readHead() throws -> Self {
    guard let head = Self._readHead() else {
      throw IOReaderError.unexpectedEOF
    }
    return head
  }
}

extension FixedWidthInteger {

  @inlinable
  @inline(__always)
  static func _readHead() -> Self? {
    while let c: Self = __getchar_unlocked() {
      if !isASCIIWhitespace(c) { return c }
    }
    return nil
  }
}

@inlinable
func _ungetc<I:FixedWidthInteger>(_ c: I?) -> Int32 {
  if let c {
    return _ungetc(Int32(c))
  }
  return EOF
}

@inlinable
func __getchar_unlocked<I:FixedWidthInteger>() -> I? {
  let c = _getchar_unlocked()
  if c == EOF {
    return nil
  }
  return numericCast(c)
}
