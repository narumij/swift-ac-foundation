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

extension IOReaderError: CustomStringConvertible {

  public var description: String {
    switch self {
    case .unexpectedNil: "input ended unexpectedly"
    case .unexpectedSpace: "found a space or line end where a value was expected"
    case .unexpectedEOF: "input ended before a value was read"
    case .unexpectedEmpty: "found an empty value"
    case .invalidInteger: "the input is not an integer"
    case .integerOutOfRange: "the integer is out of range"
    case .invalidFloatingPoint: "the input is not a number"
    case .floatingPointOutOfRange: "the number is out of range"
    case .elementCountMismatch(let expected, let actual):
      "expected \(expected) values, but read \(actual)"
    }
  }
}
