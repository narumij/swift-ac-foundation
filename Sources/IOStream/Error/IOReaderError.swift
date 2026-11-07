public enum IOReaderError: Swift.Error, Equatable {

  case unexpectedNil
  case unexpectedSpace
  case unexpectedEOF
  case unexpectedEmpty
  case invalidInteger
  case integerOutOfRange
  case invalidFloatingPoint
  case floatingPointOutOfRange
  case elementCountMismatch(expected: Int, actual: Int)
}
