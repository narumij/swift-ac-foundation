import Foundation

// MARK: - IOReader

public
  enum Error: Swift.Error
{
  case unexpectedNil
  case unexpectedSpace
  case unexpectedEOF
}

extension FixedWidthInteger {
  @inlinable @inline(__always) static var NULL: Self { 0x00 }
  @inlinable @inline(__always) static var HT: Self { 0x09 }
  @inlinable @inline(__always) static var LF: Self { 0x0A }
  @inlinable @inline(__always) static var CR: Self { 0x0D }
  @inlinable @inline(__always) static var SP: Self { 0x20 }
  @inlinable @inline(__always) static var MINUS: Self { 0x2D }
  @inlinable @inline(__always) static var ZERO: Self { 0x30 }
}

@usableFromInline
let spaces: UInt = 1 << UInt.HT | 1 << UInt.LF | 1 << UInt.CR | 1 << UInt.SP

@usableFromInline
let newlines: UInt = 1 << UInt.LF | 1 << UInt.CR

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
func nullIfEOF<T: FixedWidthInteger>(_ c: Int32) -> T {
  c == -1 ? .NULL : numericCast(c)
}

extension Optional {
  @inlinable @inline(__always)
  func unwrap(or error: @autoclosure () -> Error) throws -> Wrapped {
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
      let c = getchar_unlocked()
      if c == -1 {
        throw Error.unexpectedEOF
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
    var element: Element = 0
    var negative: Bool = false
    var c: Element = try .readHead()
    if c == .MINUS {
      negative = true
    } else {
      element = c &- .ZERO
    }
    while true {
      c = nullIfEOF(getchar_unlocked())
      if isASCIIWhitespaceOrNull(c) {
        break
      }
      element = element * 10 + (negative ? -(c &- .ZERO) : (c &- .ZERO))
    }
    return (element, UInt8(truncatingIfNeeded: c))
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
    var element: Element = 0
    var c: Element = try .readHead()
    element = c &- .ZERO
    while true {
      c = nullIfEOF(getchar_unlocked())
      if isASCIIWhitespaceOrNull(c) {
        break
      }
      element = element * 10 + (c &- .ZERO)
    }
    return (element, UInt8(truncatingIfNeeded: c))
  }
}

@usableFromInline
protocol VariableBufferIOReader: IOReader {
  associatedtype BufferElement: FixedWidthInteger
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
      current = nullIfEOF(getchar_unlocked())
    }
    return try f(buffer, current).unwrap(or: Error.unexpectedNil)
  }

  @inlinable
  @inline(__always)
  mutating func readBytes(count: Int) throws -> [BufferElement] {
    buffer.removeAll(keepingCapacity: true)
    var lastByte: BufferElement = 0
    for i in 0..<count {
      lastByte = i == 0 ? try .readHead() : nullIfEOF(getchar_unlocked())
      if lastByte == .NULL {
        throw Error.unexpectedEOF
      }
      if (1 << lastByte) & spaces != 0 {
        throw Error.unexpectedSpace
      }
      buffer.append(lastByte)
    }
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
struct _atol<Element: FixedWidthInteger & SignedInteger>: ZeroBufferIOReader, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    try Self._read().0
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    try Self._read()
  }
}

@usableFromInline
struct _atoul<Element: FixedWidthInteger & UnsignedInteger>: ZeroBufferIOReader, StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    try Self._read().0
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
  mutating func read<T>(
    _ f: (UnsafeBufferPointer<UInt8>, Int) -> T?
  ) throws -> T {
    var current = 0
    buffer.removeAll(keepingCapacity: true)
    buffer.append(try .readHead())
    while !isASCIIWhitespaceOrNull(buffer[current]) {
      current += 1
      buffer.append(nullIfEOF(getchar_unlocked()))
    }
    return try buffer.withUnsafeBufferPointer {
      try f($0, current).unwrap(or: Error.unexpectedNil)
    }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    // 末尾に区切り文字が必要な模様
    try read { b, _ in atof(b.baseAddress!) }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    // 末尾に区切り文字が必要な模様
    try read { b, c in (atof(b.baseAddress!), b[c]) }
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

let bufferCapcity = 16

@usableFromInline
struct _atob: VariableBufferIOReader, InstanceIOReader {

  @usableFromInline
  typealias Element = [UInt8]

  public var buffer: [UInt8] = {
    var b = [UInt8]()
    b.reserveCapacity(bufferCapcity)
    return b
  }()

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    try read { b, c in b }
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
    defer { getchar_unlocked() }
    return try instance.readBytes(count: count)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

@usableFromInline
struct _atoc: InstanceIOReader {

  @usableFromInline
  typealias Element = [Character]

  public var buffer: [Character] = {
    var b = [Character]()
    b.reserveCapacity(bufferCapcity)
    return b
  }()

  @inlinable
  @inline(__always)
  mutating func _read() throws -> ([Character], UInt8) {
    buffer.removeAll(keepingCapacity: true)
    var current: UInt8 = try .readHead()
    while !isASCIIWhitespaceOrNull(current) {
      buffer.append(Character(UnicodeScalar(current)))
      current = nullIfEOF(getchar_unlocked())
    }
    return (buffer, current)
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    try _read().0
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
      lastByte = i == 0 ? try .readHead() : nullIfEOF(getchar_unlocked())
      if lastByte == .NULL {
        throw Error.unexpectedEOF
      }
      if (1 << lastByte) & spaces != 0 {
        throw Error.unexpectedSpace
      }
      buffer.append(Character(UnicodeScalar(lastByte)))
    }
    return buffer
  }

  @inlinable
  @inline(__always)
  static func read(count: Int) throws -> Element {
    defer { getchar_unlocked() }
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
    b.reserveCapacity(bufferCapcity)
    return b
  }()

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {

    try read {
      (b: [UInt8], c: UInt8) in
      String(bytes: b, encoding: .ascii)
    }
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
    defer { getchar_unlocked() }
    return try String(bytes: instance.readBytes(count: count), encoding: .ascii)
      .unwrap(or: Error.unexpectedNil)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}
