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
    var c: Element = try .readHead()
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
      let digit = c - .ZERO
      value = value * 10 + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    } while isNumber(c)
    return (value, UInt8(truncatingIfNeeded: c))
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var c: Element = try .readHead()
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
      value = value * 10 + (c - .ZERO)
      c = nullIfEOF(_getchar_unlocked())
    } while isNumber(c)
    return (negative ? 0 &- value : value, UInt8(truncatingIfNeeded: c))
  }
}

// MARK: -

// 固定2・8・16進とAuto／Auto2に共通する、文字列バッファを作らない整数読取り。
// 先頭処理が「符号・読み済みの文字・基数」を決め、積み上げ処理がその続きを読む。
// 固定基数と自動判別の違いは先頭処理に収め、符号付き／符号なしの計算は分ける。
//
// 10進専用のZeroBufferIOReaderは性能上の理由で、このBaseには統合しない。
// Autoが結果として10進を選ぶ場合は、この汎用経路で読む。
// 文字・桁・計算値をElementで扱い、桁ごとの型変換を避ける。
// 戻り値の区切り文字だけ、既存の読取り契約に合わせてUInt8にする。
//
// 対象はASCII入力。NULLは既存のEOF代用値であり、入力中のNULは対象外。
// C++ストリームのfailbitや復帰機構を実装するものではない。
@usableFromInline
protocol ZeroBufferIOReaderBase: IOReader {
  associatedtype Element: FixedWidthInteger
  // 具体的な読取り型が選ぶモード。Cの実行時設定は呼出し元の_atol/_atoulが振り分ける。
  static var integerMode: FastIOIntegerMode { get }
  // firstは既に入力から取り出した文字。先頭0だけで値が成立した場合は区切りでもよい。
  static func readIntegerHead() throws -> (negative: Bool, first: Element, radix: Element)
  // isElement(c)を満たす文字を0...15の桁値へ変換する。基数内かの判定は別。
  static func element(_ c: Element) -> Element
  // 16進の候補文字かどうか。実際に読める桁かはelement(c) < radixも併せて判定する。
  static func isElement(_ c: Element) -> Bool
}

extension ZeroBufferIOReaderBase {

  // 呼出し側で候補文字と確認済みなので、ここでは範囲検査を繰り返さない。
  // 0x61/0x41はa/A。数字はASCIIの0との差がそのまま桁値になる。
  @inlinable
  @inline(__always)
  static func element(_ c: Element) -> Element {
    if c >= 0x61 { return c - 0x61 + 10 }
    if c >= 0x41 { return c - 0x41 + 10 }
    return c - .ZERO
  }

  @inlinable
  @inline(__always)
  static func isElement(_ c: Element) -> Bool {
    isNumber(c) || (c >= 0x61 && c <= 0x66) || (c >= 0x41 && c <= 0x46)
  }

  // 空白と任意の符号を消費し、必要なら接頭辞を消費して基数を確定する。
  //   Binary: 2進。0b/0Bは任意。      Octal: 8進。接頭辞処理なし。
  //   Hexadecimal: 16進。0x/0Xは任意。
  //   Auto: 0x/0Xなら16進、先頭0なら8進、それ以外は10進。
  //   Auto2: Autoに0b/0Bの2進判別を追加。
  // 固定16進での0bは接頭辞ではなく、通常の16進数字として読む。
  // 先頭0から既に8進に決まった00A0は、後続にAがあっても16進に変更しない。
  //
  // 接頭辞を消費した場合は直後に有効な桁が必要。0x!などは!を押し戻して失敗する。
  // 符号・接頭辞は失敗しても巻き戻さない。最初の空白読みでのEOFはreadHeadに従う。
  @inlinable
  @inline(__always)
  static func readIntegerHead() throws -> (negative: Bool, first: Element, radix: Element) {
    var c: Element = try .readHead()
    let negative = c == .MINUS
    if negative || c == .PLUS {
      c = nullIfEOF(_getchar_unlocked())
    }

    let mode = integerMode
    let automatic = mode == FastIOIntegerAuto || mode == FastIOIntegerAuto2
    // 固定モードのrawValueは基数そのもの。Auto/Auto2の0/1は基数に使わない。
    var radix: Element = automatic ? 10 : Element(mode.rawValue)
    if c == .ZERO && (automatic || mode == FastIOIntegerHexadecimal || mode == FastIOIntegerBinary)
    {
      // 先頭0は桁として消費済み。次の文字で接頭辞か、通常の続きかを見分ける。
      if automatic { radix = 8 }
      c = nullIfEOF(_getchar_unlocked())
      if (automatic || mode == FastIOIntegerHexadecimal) && (c == 0x78 || c == 0x58) {
        radix = 16
        c = nullIfEOF(_getchar_unlocked())
      } else if (mode == FastIOIntegerAuto2 || mode == FastIOIntegerBinary)
        && (c == 0x62 || c == 0x42)
      {
        radix = 2
        c = nullIfEOF(_getchar_unlocked())
      } else if !isElement(c) || element(c) >= radix {
        // 接頭辞ではない先頭0だけでも値は成立する。次の文字は区切りとして返す。
        // 例: Autoの09 → 0と残り9、0b11 → 0と残りb11、0 EOF → 0とNULL。
        // _readのループはこの文字を数値に加えず、値0のまま終了する。
        return (negative, c, radix)
      }
    }
    guard isElement(c), element(c) < radix else {
      if c != .NULL { _ = _ungetc(Int32(c)) }
      throw IOReaderError.invalidInteger
    }
    return (negative, c, radix)
  }

  // 最初の非数字まで1文字先読みする。ここでは押し戻さず、値と一緒に返す。
  // 値だけを返す上位のreadはvaluePreservingSeparatorで押し戻す。
  // 区切り付きのreadはその文字を消費済みとして受け取る。この契約を変えない。
  //
  // 負数は各桁を引いて積み上げる。正の絶対値を経由しないため、最小値も表現できる。
  // 範囲外の積み上げは通常の演算子のオーバーフロー検査に任せる。
  // 例外化や残りの数字列を最後まで消費する処理は、ここへ追加していない。
  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var (negative, c, radix) = try readIntegerHead()

    var value: Element = 0
    while isElement(c) && element(c) < radix {
      let digit = element(c)
      value = value * radix + (negative ? -digit : digit)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (value, UInt8(truncatingIfNeeded: c))
  }

  // 符号なしは正の値を積み上げ、負号があれば最後に0 &- valueで符号を反映する。
  // 最後の減算だけが折返し演算。桁の積み上げ自体を折り返す仕様ではない。
  // 区切りの先読み・返却は符号付きと同じ。
  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var (negative, c, radix) = try readIntegerHead()

    var value: Element = 0
    while isElement(c) && element(c) < radix {
      value = value * radix + element(c)
      c = nullIfEOF(_getchar_unlocked())
    }
    return (negative ? 0 &- value : value, UInt8(truncatingIfNeeded: c))
  }
}

@usableFromInline
protocol ZeroBufferIOReader2: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReader2 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerBinary }
}

@usableFromInline
protocol ZeroBufferIOReader8: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReader8 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerOctal }
}

@usableFromInline
protocol ZeroBufferIOReader16: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReader16 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerHexadecimal }
}

@usableFromInline
protocol ZeroBufferIOReaderAuto: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReaderAuto {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerAuto }
}

@usableFromInline
protocol ZeroBufferIOReaderAuto2: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReaderAuto2 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerAuto2 }
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
protocol StaticIOSubReader: StaticIOReader {
  static func _read() throws -> (Element, UInt8)
}

extension StaticIOSubReader {

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
    valuePreservingSeparator(try read() as (value: Element, separator: UInt8))
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atolAuto<Element>.read()
    case FastIOIntegerAuto2:
      return try _atolAuto2<Element>.read()
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
    valuePreservingSeparator(try read() as (value: Element, separator: UInt8))
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atoulAuto<Element>.read()
    case FastIOIntegerAuto2:
      return try _atoulAuto2<Element>.read()
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
struct _atol10<Element: FixedWidthInteger & SignedInteger>:
  ZeroBufferIOReader, StaticIOSubReader
{}

@usableFromInline
struct _atoul10<Element: FixedWidthInteger & UnsignedInteger>:
  ZeroBufferIOReader, StaticIOSubReader
{}

@usableFromInline
struct _atol16<Element: FixedWidthInteger & SignedInteger>:
  ZeroBufferIOReader16, StaticIOSubReader
{}

@usableFromInline
struct _atoul16<Element: FixedWidthInteger & UnsignedInteger>:
  ZeroBufferIOReader16, StaticIOSubReader
{}

@usableFromInline
struct _atol2<Element: FixedWidthInteger & SignedInteger>:
  ZeroBufferIOReader2, StaticIOSubReader
{}

@usableFromInline
struct _atoul2<Element: FixedWidthInteger & UnsignedInteger>:
  ZeroBufferIOReader2, StaticIOSubReader
{}

@usableFromInline
struct _atol8<Element: FixedWidthInteger & SignedInteger>:
  ZeroBufferIOReader8, StaticIOSubReader
{}

@usableFromInline
struct _atoul8<Element: FixedWidthInteger & UnsignedInteger>:
  ZeroBufferIOReader8, StaticIOSubReader
{}

@usableFromInline
struct _atolAuto<Element: FixedWidthInteger & SignedInteger>:
  ZeroBufferIOReaderAuto, StaticIOSubReader
{}

@usableFromInline
struct _atoulAuto<Element: FixedWidthInteger & UnsignedInteger>:
  ZeroBufferIOReaderAuto, StaticIOSubReader
{}

@usableFromInline
struct _atolAuto2<Element: FixedWidthInteger & SignedInteger>:
  ZeroBufferIOReaderAuto2, StaticIOSubReader
{}

@usableFromInline
struct _atoulAuto2<Element: FixedWidthInteger & UnsignedInteger>:
  ZeroBufferIOReaderAuto2, StaticIOSubReader
{}

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
