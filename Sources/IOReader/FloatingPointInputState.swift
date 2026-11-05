// ASCII / classic localeでの浮動小数入力の切出し。
// advanceは文字を消費する場合だけtrueを返す。数値変換はstrtodに任せる。

@usableFromInline
protocol FloatingPointInputState {
  var isComplete: Bool { get }
  mutating func advance(_ c: UInt8) -> Bool
}

@usableFromInline
enum StrtodFloatingPointState: FloatingPointInputState {
  case start, sign, zero, integer, leadingPoint, fraction
  case hexPrefix, hexInteger, hexLeadingPoint, hexFraction
  case exponent, exponentSign, exponentDigits
  case i, infN, inf, infI, infIN, infINI, infINIT, infinity
  case n, nanA, nan, nanPayload, complete

  @inlinable
  var isComplete: Bool {
    switch self {
    case .zero, .integer, .fraction, .hexInteger, .hexFraction,
         .exponentDigits, .inf, .infinity, .nan, .complete: return true
    default: return false
    }
  }

  @inlinable
  mutating func advance(_ c: UInt8) -> Bool {
    let lower = c | 0x20
    let digit = c >= UInt8(ascii: "0") && c <= UInt8(ascii: "9")
    let hexDigit = digit || (lower >= UInt8(ascii: "a") && lower <= UInt8(ascii: "f"))
    switch self {
    case .start:
      if c == UInt8(ascii: "+") || c == UInt8(ascii: "-") { self = .sign; return true }
      fallthrough
    case .sign:
      if c == UInt8(ascii: "0") { self = .zero }
      else if digit { self = .integer }
      else if c == UInt8(ascii: ".") { self = .leadingPoint }
      else if lower == UInt8(ascii: "i") { self = .i }
      else if lower == UInt8(ascii: "n") { self = .n }
      else { return false }
    case .zero:
      if lower == UInt8(ascii: "x") { self = .hexPrefix; return true }
      fallthrough
    case .integer:
      if digit { self = .integer }
      else if c == UInt8(ascii: ".") { self = .fraction }
      else if lower == UInt8(ascii: "e") { self = .exponent }
      else { return false }
    case .leadingPoint:
      guard digit else { return false }
      self = .fraction
    case .fraction:
      if digit { return true }
      if lower == UInt8(ascii: "e") { self = .exponent } else { return false }
    case .hexPrefix:
      if hexDigit { self = .hexInteger }
      else if c == UInt8(ascii: ".") { self = .hexLeadingPoint }
      else { return false }
    case .hexInteger:
      if hexDigit { return true }
      if c == UInt8(ascii: ".") { self = .hexFraction }
      else if lower == UInt8(ascii: "p") { self = .exponent }
      else { return false }
    case .hexLeadingPoint:
      guard hexDigit else { return false }
      self = .hexFraction
    case .hexFraction:
      if hexDigit { return true }
      if lower == UInt8(ascii: "p") { self = .exponent } else { return false }
    case .exponent:
      if c == UInt8(ascii: "+") || c == UInt8(ascii: "-") { self = .exponentSign; return true }
      fallthrough
    case .exponentSign:
      guard digit else { return false }
      self = .exponentDigits
    case .exponentDigits:
      return digit
    case .i:
      guard lower == UInt8(ascii: "n") else { return false }; self = .infN
    case .infN:
      guard lower == UInt8(ascii: "f") else { return false }; self = .inf
    case .inf:
      guard lower == UInt8(ascii: "i") else { return false }; self = .infI
    case .infI:
      guard lower == UInt8(ascii: "n") else { return false }; self = .infIN
    case .infIN:
      guard lower == UInt8(ascii: "i") else { return false }; self = .infINI
    case .infINI:
      guard lower == UInt8(ascii: "t") else { return false }; self = .infINIT
    case .infINIT:
      guard lower == UInt8(ascii: "y") else { return false }; self = .infinity
    case .n:
      guard lower == UInt8(ascii: "a") else { return false }; self = .nanA
    case .nanA:
      guard lower == UInt8(ascii: "n") else { return false }; self = .nan
    case .nan:
      guard c == UInt8(ascii: "(") else { return false }; self = .nanPayload
    case .nanPayload:
      if c == UInt8(ascii: ")") { self = .complete }
      else if digit || (lower >= UInt8(ascii: "a") && lower <= UInt8(ascii: "z")) || c == UInt8(ascii: "_") { return true }
      else { return false }
    case .infinity, .complete:
      return false
    }
    return true
  }
}

// libc++型：候補文字を広く収集し、候補全体の可否を変換側で判定する。
@usableFromInline
struct LLVMFloatingPointState: FloatingPointInputState {
  @usableFromInline
  enum Phase { case start, sign, significand, afterPointOrExponent }
  @usableFromInline var phase: Phase = .start
  @usableFromInline var exponent: UInt8 = UInt8(ascii: "e")
  @usableFromInline var previous: UInt8 = 0

  @inlinable var isComplete: Bool { true }

  @inlinable
  init() {}

  @inlinable
  mutating func advance(_ c: UInt8) -> Bool {
    let lower = c | 0x20
    let digit = c >= UInt8(ascii: "0") && c <= UInt8(ascii: "9")
    switch c {
    case UInt8(ascii: "+"), UInt8(ascii: "-"):
      guard phase == .start || (previous | 0x20) == exponent else { return false }
      if phase == .start { phase = .sign }
    case UInt8(ascii: "."):
      guard phase != .afterPointOrExponent else { return false }
      phase = .afterPointOrExponent
    default:
      guard digit || (lower >= UInt8(ascii: "a") && lower <= UInt8(ascii: "f")) || lower == UInt8(ascii: "x") || lower == UInt8(ascii: "p") else {
        return false
      }
      if phase == .start || phase == .sign {
        guard digit else { return false }
        phase = .significand
      }
      if lower == UInt8(ascii: "x") { exponent = UInt8(ascii: "p") }
      else if lower == exponent { phase = .afterPointOrExponent }
    }
    previous = c
    return true
  }
}
