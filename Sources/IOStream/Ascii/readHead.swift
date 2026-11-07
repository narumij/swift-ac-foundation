import _FastIO

extension FixedWidthInteger {

  @inlinable
  @inline(__always)
  static func readHead() throws -> Self {
    var head: Self
    repeat {
      let c = _getchar_unlocked()
      if c == -1 {
        throw IOReaderError.unexpectedEOF
      }
      head = numericCast(c)
    } while (1 << head) & spaces != 0
    return head
  }
}

@inlinable
func __getchar_unlocked<I:FixedWidthInteger>() -> I? {
  let c = _getchar_unlocked()
  if c == EOF {
    return nil
  }
  return numericCast(c)
}

@inlinable
func __ungetc<I:FixedWidthInteger>(_ c: I?) -> Int32 {
  if let c {
    return _ungetc(Int32(c))
  }
  return EOF
}

