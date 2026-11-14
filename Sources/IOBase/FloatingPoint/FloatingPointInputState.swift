// ASCII / classic localeでの浮動小数入力の切出し。
// advanceは文字を消費する場合だけtrueを返す。数値変換はstrtodに任せる。

@usableFromInline
protocol FloatingPointInputState {
  var isComplete: Bool { get }
  mutating func advance(_ c: UInt8) -> Bool
}

// strtodの構文。10進と16進は同じ形で、数字の種類と指数の文字だけが違う。
// allowsHexがfalseなら0xへ進まない（GCC型。GCC完全互換ではない）。
@usableFromInline
struct StrtodFloatingPointState: FloatingPointInputState {

  @usableFromInline
  enum Phase: Equatable {
    case start, sign, zero, hexPrefix
    case integer, leadingPoint, fraction
    case exponent, exponentSign, exponentDigits
    case inf(matched: Int), nan(matched: Int), nanPayload, complete
  }

  @usableFromInline static let infinityLetters = Array("infinity".utf8)
  @usableFromInline static let nanLetters = Array("nan".utf8)

  @usableFromInline var phase = Phase.start
  @usableFromInline var hex = false
  @usableFromInline let allowsHex: Bool

  @inlinable
  init(allowsHex: Bool) {
    self.allowsHex = allowsHex
  }

  @inlinable
  var isComplete: Bool {
    switch phase {
    case .zero, .integer, .fraction, .exponentDigits,
         .inf(matched: 3), .inf(matched: 8), .nan(matched: 3), .complete: return true
    default: return false
    }
  }

  @inlinable
  mutating func advance(_ c: UInt8) -> Bool {
    let lower = c | 0x20
    let decimal = c >= UInt8(ascii: "0") && c <= UInt8(ascii: "9")
    let digit = decimal || (hex && lower >= UInt8(ascii: "a") && lower <= UInt8(ascii: "f"))
    let exponentMarker = hex ? UInt8(ascii: "p") : UInt8(ascii: "e")
    switch phase {
    case .start:
      if c == UInt8(ascii: "+") || c == UInt8(ascii: "-") { phase = .sign; return true }
      fallthrough
    case .sign:
      if c == UInt8(ascii: "0") { phase = .zero }
      else if decimal { phase = .integer }
      else if c == UInt8(ascii: ".") { phase = .leadingPoint }
      else if lower == UInt8(ascii: "i") { phase = .inf(matched: 1) }
      else if lower == UInt8(ascii: "n") { phase = .nan(matched: 1) }
      else { return false }
    case .zero:
      if allowsHex, lower == UInt8(ascii: "x") { phase = .hexPrefix; hex = true; return true }
      fallthrough
    case .integer:
      if digit { phase = .integer }
      else if c == UInt8(ascii: ".") { phase = .fraction }
      else if lower == exponentMarker { phase = .exponent }
      else { return false }
    case .hexPrefix:
      if digit { phase = .integer }
      else if c == UInt8(ascii: ".") { phase = .leadingPoint }
      else { return false }
    case .leadingPoint:
      guard digit else { return false }
      phase = .fraction
    case .fraction:
      if digit { return true }
      guard lower == exponentMarker else { return false }
      phase = .exponent
    case .exponent:
      if c == UInt8(ascii: "+") || c == UInt8(ascii: "-") { phase = .exponentSign; return true }
      fallthrough
    case .exponentSign:
      guard decimal else { return false }
      phase = .exponentDigits
    case .exponentDigits:
      return decimal
    case .inf(let matched):
      let letters = Self.infinityLetters
      guard matched < letters.count, lower == letters[matched] else { return false }
      phase = .inf(matched: matched + 1)
    case .nan(let matched):
      let letters = Self.nanLetters
      if matched < letters.count {
        guard lower == letters[matched] else { return false }
        phase = .nan(matched: matched + 1)
      } else {
        guard c == UInt8(ascii: "(") else { return false }
        phase = .nanPayload
      }
    case .nanPayload:
      if c == UInt8(ascii: ")") { phase = .complete }
      else if decimal || (lower >= UInt8(ascii: "a") && lower <= UInt8(ascii: "z")) || c == UInt8(ascii: "_") { return true }
      else { return false }
    case .complete:
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
