import Foundation
@preconcurrency import _FastIO

// MARK: - IOReader

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

extension FixedWidthInteger {
  @inlinable @inline(__always) static var NULL: Self { 0x00 }
  @inlinable @inline(__always) static var HT: Self { 0x09 }
  @inlinable @inline(__always) static var LF: Self { 0x0A }
  @inlinable @inline(__always) static var VT: Self { 0x0B }
  @inlinable @inline(__always) static var FF: Self { 0x0C }
  @inlinable @inline(__always) static var CR: Self { 0x0D }
  @inlinable @inline(__always) static var SP: Self { 0x20 }

  @inlinable @inline(__always) static var PLUS: Self { 0x2B }
  @inlinable @inline(__always) static var MINUS: Self { 0x2D }
  @inlinable @inline(__always) static var ZERO: Self { 0x30 }
}

@usableFromInline
let spaces: UInt =
  1 << UInt.HT | 1 << UInt.LF | 1 << UInt.VT | 1 << UInt.FF | 1 << UInt.CR | 1 << UInt.SP

@usableFromInline
let newlines: UInt = 1 << UInt.LF | 1 << UInt.CR

@usableFromInline
let numbers: UInt =
  1 << 0x30 | 1 << 0x31 | 1 << 0x32 | 1 << 0x33 | 1 << 0x34 | 1 << 0x35 | 1 << 0x36 | 1 << 0x37 | 1
  << 0x38 | 1 << 0x39

@inlinable
@inline(__always)
func isASCIIWhitespaceOrNull<T: FixedWidthInteger>(_ c: T) -> Bool {
  c == .NULL || (1 << c) & spaces != 0
}

@inlinable
@inline(__always)
func isASCIINewlineOrNull<T: FixedWidthInteger>(_ c: T) -> Bool {
  c == .NULL || (1 << c) & newlines != 0
}

@inlinable
@inline(__always)
func isNumber<T: FixedWidthInteger>(_ c: T) -> Bool {
  c >= .ZERO && c <= .ZERO + 9
}

@inlinable
@inline(__always)
func nullIfEOF<T: FixedWidthInteger>(_ c: Int32) -> T {
  c == -1 ? .NULL : numericCast(c)
}

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

@usableFromInline
protocol IOReader {}

@usableFromInline
protocol ZeroBufferIOReader: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReader {

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }
    guard isNumber(c) else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    repeat {
      let digit = Element(c - .ZERO)
      value = value * 10 + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    } while isNumber(c)
    return (value, c)
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }
    guard isNumber(c) else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    repeat {
      value = value * 10 + Element(c - .ZERO)
      c = nullIfEOF(_getchar_unlocked())
    } while isNumber(c)
    return (negative ? 0 &- value : value, c)
  }
}

// 16進読取り。十進側とは独立して形を検討する。
@usableFromInline
protocol ZeroBufferIOReader16: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReader16 {

  @inlinable
  @inline(__always)
  static func hexDigit(_ c: UInt8) -> UInt8? {
    switch c {
    case UInt8(ascii: "0")...UInt8(ascii: "9"):
      return c - UInt8(ascii: "0")
    case UInt8(ascii: "a")...UInt8(ascii: "f"):
      return c - UInt8(ascii: "a") + 10
    case UInt8(ascii: "A")...UInt8(ascii: "F"):
      return c - UInt8(ascii: "A") + 10
    default:
      return nil
    }
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    // 先頭の0は値として読める。直後がx/Xの場合だけ接頭辞として扱う。
    if c == .ZERO {
      c = nullIfEOF(_getchar_unlocked())
      if c == UInt8(ascii: "x") || c == UInt8(ascii: "X") {
        c = nullIfEOF(_getchar_unlocked())
      } else if hexDigit(c) == nil {
        return (0, c)
      }
    }
    guard hexDigit(c) != nil else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = hexDigit(c) {
      let digit = Element(digit)
      value = value * 16 + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (value, c)
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    // 先頭の0は値として読める。直後がx/Xの場合だけ接頭辞として扱う。
    if c == .ZERO {
      c = nullIfEOF(_getchar_unlocked())
      if c == UInt8(ascii: "x") || c == UInt8(ascii: "X") {
        c = nullIfEOF(_getchar_unlocked())
      } else if hexDigit(c) == nil {
        return (0, c)
      }
    }
    guard hexDigit(c) != nil else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = hexDigit(c) {
      value = value * 16 + Element(digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (negative ? 0 &- value : value, c)
  }
}

// 2進読取り。基数ごとの実装を独立して保つ。
@usableFromInline
protocol ZeroBufferIOReader2: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReader2 {

  @inlinable
  @inline(__always)
  static func binaryDigit(_ c: UInt8) -> UInt8? {
    switch c {
    case UInt8(ascii: "0")...UInt8(ascii: "1"):
      return c - UInt8(ascii: "0")
    default:
      return nil
    }
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    // 先頭の0は値として読める。直後がb/Bの場合だけ接頭辞として扱う。
    if c == .ZERO {
      c = nullIfEOF(_getchar_unlocked())
      if c == UInt8(ascii: "b") || c == UInt8(ascii: "B") {
        c = nullIfEOF(_getchar_unlocked())
      } else if binaryDigit(c) == nil {
        return (0, c)
      }
    }
    guard binaryDigit(c) != nil else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = binaryDigit(c) {
      let digit = Element(digit)
      value = value * 2 + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (value, c)
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    // 先頭の0は値として読める。直後がb/Bの場合だけ接頭辞として扱う。
    if c == .ZERO {
      c = nullIfEOF(_getchar_unlocked())
      if c == UInt8(ascii: "b") || c == UInt8(ascii: "B") {
        c = nullIfEOF(_getchar_unlocked())
      } else if binaryDigit(c) == nil {
        return (0, c)
      }
    }
    guard binaryDigit(c) != nil else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = binaryDigit(c) {
      value = value * 2 + Element(digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (negative ? 0 &- value : value, c)
  }
}

// 8進読取り。基数ごとの実装を独立して保つ。
@usableFromInline
protocol ZeroBufferIOReader8: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReader8 {

  @inlinable
  @inline(__always)
  static func octalDigit(_ c: UInt8) -> UInt8? {
    switch c {
    case UInt8(ascii: "0")...UInt8(ascii: "7"):
      return c - UInt8(ascii: "0")
    default:
      return nil
    }
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    guard octalDigit(c) != nil else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = octalDigit(c) {
      let digit = Element(digit)
      value = value * 8 + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (value, c)
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    guard octalDigit(c) != nil else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = octalDigit(c) {
      value = value * 8 + Element(digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (negative ? 0 &- value : value, c)
  }
}

@usableFromInline
protocol ZeroBufferIOReaderAuto: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReaderAuto {

  @inlinable
  @inline(__always)
  static func hexDigit(_ c: UInt8) -> UInt8? {
    switch c {
    case UInt8(ascii: "0")...UInt8(ascii: "9"):
      return c - UInt8(ascii: "0")
    case UInt8(ascii: "a")...UInt8(ascii: "f"):
      return c - UInt8(ascii: "a") + 10
    case UInt8(ascii: "A")...UInt8(ascii: "F"):
      return c - UInt8(ascii: "A") + 10
    default:
      return nil
    }
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    var radix: Element = 10
    // cinの自動判別：0x/0Xは16進、先頭0は8進、それ以外は10進。
    if c == .ZERO {
      radix = 8
      c = nullIfEOF(_getchar_unlocked())
      if c == UInt8(ascii: "x") || c == UInt8(ascii: "X") {
        radix = 16
        c = nullIfEOF(_getchar_unlocked())
      } else if !(UInt8(ascii: "0")...UInt8(ascii: "7")).contains(c) {
        return (0, c)
      }
    }
    guard let firstDigit = hexDigit(c), Element(firstDigit) < radix else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = hexDigit(c), Element(digit) < radix {
      let digit = Element(digit)
      value = value * radix + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (value, c)
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var c: UInt8 = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    var radix: Element = 10
    // cinの自動判別：0x/0Xは16進、先頭0は8進、それ以外は10進。
    if c == .ZERO {
      radix = 8
      c = nullIfEOF(_getchar_unlocked())
      if c == UInt8(ascii: "x") || c == UInt8(ascii: "X") {
        radix = 16
        c = nullIfEOF(_getchar_unlocked())
      } else if !(UInt8(ascii: "0")...UInt8(ascii: "7")).contains(c) {
        return (0, c)
      }
    }
    guard let firstDigit = hexDigit(c), Element(firstDigit) < radix else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let digit = hexDigit(c), Element(digit) < radix {
      value = value * radix + Element(digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (negative ? 0 &- value : value, c)
  }
}

public enum IOConfig {
  nonisolated(unsafe)
    public static var bufferPolicy = BufferPolicy.default
}

extension IOConfig {

  public struct BufferPolicy {
    public var minCapacity: Int
    public var maxCapacity: Int
    public static var `default`: BufferPolicy {
      BufferPolicy(
        minCapacity: 16,
        maxCapacity: 1 << 20
      )
    }
  }
}

@usableFromInline
protocol VariableBuffer {
  associatedtype BufferElement
  var buffer: [BufferElement] { get set }
}

extension VariableBuffer {

  @inlinable
  @inline(__always)
  mutating func resetBufferIfNeeded() {
    let policy = IOConfig.bufferPolicy
    if buffer.capacity > policy.maxCapacity {
      buffer = []
      buffer.reserveCapacity(policy.maxCapacity)
    }
  }
}

@usableFromInline
protocol VariableBufferIOReader: IOReader, VariableBuffer where BufferElement: FixedWidthInteger {
  var buffer: [BufferElement] { get set }
}

extension VariableBufferIOReader {

  @inlinable
  @inline(__always)
  mutating func read<T>(
    _ f: ([BufferElement], BufferElement) -> T?
  ) throws -> T {
    buffer.removeAll(keepingCapacity: true)
    var current: BufferElement = try .readHead()
    while !isASCIIWhitespaceOrNull(current) {
      buffer.append(current)
      current = nullIfEOF(_getchar_unlocked())
    }
    defer { resetBufferIfNeeded() }
    return try f(buffer, current).unwrap(or: IOReaderError.unexpectedNil)
  }

  @inlinable
  @inline(__always)
  mutating func readBytes(count: Int) throws -> [BufferElement] {
    buffer.removeAll(keepingCapacity: true)
    var lastByte: BufferElement = 0
    for i in 0..<count {
      lastByte = i == 0 ? try .readHead() : nullIfEOF(_getchar_unlocked())
      if lastByte == .NULL {
        throw IOReaderError.unexpectedEOF
      }
      if (1 << lastByte) & spaces != 0 {
        throw IOReaderError.unexpectedSpace
      }
      buffer.append(lastByte)
    }
    defer { resetBufferIfNeeded() }
    return buffer
  }
}

@usableFromInline
protocol StaticIOReader {
  associatedtype Element
  static func read() throws -> Element
  static func read() throws -> (value: Element, separator: UInt8)
}

extension StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read<T>(_ f: (Element) throws -> T) throws -> (value: T, separator: UInt8) {
    let (a, b) = try read()
    return (try f(a), b)
  }
}

@usableFromInline
protocol InstanceIOReader {
  associatedtype Element
  mutating func read() throws -> Element
  mutating func read() throws -> Item
  static var instance: Self { get set }
}

extension InstanceIOReader {

  @usableFromInline
  typealias Item = (value: Element, separator: UInt8)

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    try instance.read()
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try instance.read()
  }

  @inlinable
  @inline(__always)
  public static func read<T>(_ f: (Element) throws -> T) throws -> (value: T, separator: UInt8) {
    let (a, b) = try instance.read()
    return (try f(a), b)
  }
}

@usableFromInline
struct _atol<Element: FixedWidthInteger & SignedInteger>: StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atolAuto<Element>.read()
    case FastIOIntegerBinary:
      return try _atol2<Element>.read()
    case FastIOIntegerOctal:
      return try _atol8<Element>.read()
    case FastIOIntegerDecimal:
      return try _atol10<Element>.read()
    case FastIOIntegerHexadecimal:
      return try _atol16<Element>.read()
    default:
      fatalError("Integer input mode is not implemented")
    }
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atolAuto<Element>.read()
    case FastIOIntegerBinary:
      return try _atol2<Element>.read()
    case FastIOIntegerOctal:
      return try _atol8<Element>.read()
    case FastIOIntegerDecimal:
      return try _atol10<Element>.read()
    case FastIOIntegerHexadecimal:
      return try _atol16<Element>.read()
    default:
      fatalError("Integer input mode is not implemented")
    }
  }
}

@usableFromInline
struct _atoul<Element: FixedWidthInteger & UnsignedInteger>: StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atoulAuto<Element>.read()
    case FastIOIntegerBinary:
      return try _atoul2<Element>.read()
    case FastIOIntegerOctal:
      return try _atoul8<Element>.read()
    case FastIOIntegerDecimal:
      return try _atoul10<Element>.read()
    case FastIOIntegerHexadecimal:
      return try _atoul16<Element>.read()
    default:
      fatalError("Integer input mode is not implemented")
    }
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atoulAuto<Element>.read()
    case FastIOIntegerBinary:
      return try _atoul2<Element>.read()
    case FastIOIntegerOctal:
      return try _atoul8<Element>.read()
    case FastIOIntegerDecimal:
      return try _atoul10<Element>.read()
    case FastIOIntegerHexadecimal:
      return try _atoul16<Element>.read()
    default:
      fatalError("Integer input mode is not implemented")
    }
  }
}

@usableFromInline
struct _atol10<Element: FixedWidthInteger & SignedInteger>: ZeroBufferIOReader, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atoul10<Element: FixedWidthInteger & UnsignedInteger>: ZeroBufferIOReader, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atol16<Element: FixedWidthInteger & SignedInteger>: ZeroBufferIOReader16, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atoul16<Element: FixedWidthInteger & UnsignedInteger>: ZeroBufferIOReader16, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atol2<Element: FixedWidthInteger & SignedInteger>: ZeroBufferIOReader2, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atoul2<Element: FixedWidthInteger & UnsignedInteger>: ZeroBufferIOReader2, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atol8<Element: FixedWidthInteger & SignedInteger>: ZeroBufferIOReader8, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atoul8<Element: FixedWidthInteger & UnsignedInteger>: ZeroBufferIOReader8, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atolAuto<Element: FixedWidthInteger & SignedInteger>: ZeroBufferIOReaderAuto, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atoulAuto<Element: FixedWidthInteger & UnsignedInteger>: ZeroBufferIOReaderAuto, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atof: InstanceIOReader {

  @usableFromInline
  typealias Element = Double

  public var buffer: [UInt8] = []

  @inlinable
  @inline(__always)
  func convert(_ buffer: inout [UInt8], isComplete: Bool) throws -> Double {

    let count = buffer.count
    buffer.append(.NULL)

    return try buffer.withUnsafeMutableBytes {
      try $0.baseAddress!.withMemoryRebound(to: CChar.self, capacity: $0.count) { start in

        guard count > 0, isComplete else {
          throw IOReaderError.invalidFloatingPoint
        }

        var end: UnsafeMutablePointer<CChar>?

        let savedErrno = errno
        defer { errno = savedErrno }
        errno = 0
        let value = strtod(start, &end)
        guard errno != ERANGE else {
          throw IOReaderError.floatingPointOutOfRange
        }

        guard let end, end - start == count else {
          throw IOReaderError.invalidFloatingPoint
        }

        return value
      }
    }
  }

  @inlinable
  @inline(__always)
  mutating func read<State: FloatingPointInputState>(state initialState: State) throws -> Item {
    buffer.removeAll(keepingCapacity: true)
    var c: UInt8 = try .readHead()
    var state = initialState
    while c != .NULL && state.advance(c) {
      buffer.append(c)
      c = nullIfEOF(_getchar_unlocked())
    }
    let count = buffer.count
    do {
      return (try convert(&buffer, isComplete: state.isComplete), c)
    } catch {
      if c != .NULL {
        _ = _ungetc(Int32(c))
      }
      if let reason = error as? IOReaderError {
        throw FloatingPointInputError(
          reason: reason,
          input: String(decoding: buffer.prefix(count), as: UTF8.self),
          nextByte: c == .NULL ? nil : c
        )
      }
      throw error
    }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    switch _fastio_floating_point_mode {
    case FastIOFloatingPointLLVM:
      return try read(state: LLVMFloatingPointState())
    case FastIOFloatingPointGCCLike:
      return try read(state: GCCLikeFloatingPointState())
    default:
      return try read(state: StrtodFloatingPointState.start)
    }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    valuePreservingSeparator(try read() as Item)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

@usableFromInline
struct _atob: VariableBufferIOReader, InstanceIOReader {

  @usableFromInline
  typealias Element = [UInt8]

  public var buffer: [UInt8] = {
    var b = [UInt8]()
    b.reserveCapacity(IOConfig.bufferPolicy.minCapacity)
    return b
  }()

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    valuePreservingSeparator(try read() as Item)
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try read { b, c in
      (b, c)
    }
  }

  @inlinable
  @inline(__always)
  static func read(count: Int) throws -> Element {
    return try instance.readBytes(count: count)
  }

  @inlinable
  @inline(__always)
  static func readAscii() throws -> UInt8 {
    while true {
      let c = _getchar_unlocked()
      if c == -1 { throw IOReaderError.unexpectedEOF }
      if c == 0x20 || (0x09...0x0D).contains(c) { continue }
      return UInt8(c)
    }
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

@usableFromInline
struct _atoc: InstanceIOReader, VariableBuffer {

  @usableFromInline
  typealias Element = [Character]

  public var buffer: [Character] = {
    var b = [Character]()
    b.reserveCapacity(IOConfig.bufferPolicy.minCapacity)
    return b
  }()

  @inlinable
  @inline(__always)
  mutating func _read() throws -> ([Character], UInt8) {
    buffer.removeAll(keepingCapacity: true)
    var current: UInt8 = try .readHead()
    while !isASCIIWhitespaceOrNull(current) {
      buffer.append(Character(UnicodeScalar(current)))
      current = nullIfEOF(_getchar_unlocked())
    }
    defer { resetBufferIfNeeded() }
    return (buffer, current)
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    valuePreservingSeparator(try _read())
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try _read()
  }

  @inlinable
  @inline(__always)
  mutating func _readCharacters(count: Int) throws -> Element {
    buffer.removeAll(keepingCapacity: true)
    var lastByte: UInt8 = 0
    for i in 0..<count {
      lastByte = i == 0 ? try .readHead() : nullIfEOF(_getchar_unlocked())
      if lastByte == .NULL {
        throw IOReaderError.unexpectedEOF
      }
      if (1 << lastByte) & spaces != 0 {
        throw IOReaderError.unexpectedSpace
      }
      buffer.append(Character(UnicodeScalar(lastByte)))
    }
    defer { resetBufferIfNeeded() }
    return buffer
  }

  @inlinable
  @inline(__always)
  static func read(count: Int) throws -> Element {
    return try instance._readCharacters(count: count)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

@usableFromInline
struct _atos: VariableBufferIOReader, InstanceIOReader {

  @usableFromInline
  typealias Element = String

  public var buffer: [UInt8] = {
    var b = [UInt8]()
    b.reserveCapacity(IOConfig.bufferPolicy.minCapacity)
    return b
  }()

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    valuePreservingSeparator(try read() as Item)
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {

    try read { (b: [UInt8], c: UInt8) in
      String(
        bytes: b,
        encoding: .ascii
      ).map { ($0, c) }
    }
  }

  @inlinable
  @inline(__always)
  static func read(count: Int) throws -> Element {
    return try String(bytes: instance.readBytes(count: count), encoding: .ascii)
      .unwrap(or: IOReaderError.unexpectedNil)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}
