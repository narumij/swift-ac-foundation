@preconcurrency import Foundation

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

@usableFromInline
protocol IOReader {}

@usableFromInline
protocol ZeroBufferIOReader: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReader {

  @inlinable
  @inline(__always)
  mutating func _read() throws -> (Element, UInt8) where Element: SignedInteger {
    var element: Element = 0
    var negative: Bool = false
    var c: Element = try .readHead()
    if c == .MINUS {
      negative = true
    } else {
      element = c - .ZERO
    }
    while true {
      c = nullIfEOF(getchar_unlocked())
      if isASCIIWhitespaceOrNull(c) {
        break
      }
      element = element * 10 + (negative ? -(c - .ZERO) : (c - .ZERO))
    }
    return (element, UInt8(truncatingIfNeeded: c))
  }

//  @inlinable
//  @inline(__always)
//  mutating func _read() throws -> (Element, UInt8) where Element: UnsignedInteger {
//    var element: Element = 0
//    var c: Element = try .readHead()
//    element = c - .ZERO
//    while true {
//      c = nullIfEOF(getchar_unlocked())
//      if isASCIIWhitespaceOrNull(c) {
//        break
//      }
//      element = element * 10 + (c - .ZERO)
//    }
//    return (element, UInt8(truncatingIfNeeded: c))
//  }
}

@usableFromInline
protocol FixedBufferIOReader: IOReader {
  var capacity: Int { get }
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

extension Array where Element: FixedWidthInteger {

  @inlinable
  @inline(__always)
  static func readBytes(count: Int) throws -> Self {
    return try .init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      var current = 0
      buffer[current] = try .readHead()
      while current < count - 1, !isASCIIWhitespaceOrNull(buffer[current]) {
        current += 1
        buffer[current] = nullIfEOF(getchar_unlocked())
      }
      if buffer[current] == .NULL {
        throw Error.unexpectedEOF
      }
      if (1 << buffer[current]) & spaces != 0 {
        throw Error.unexpectedSpace
      }
      initializedCount = count
    }
  }
}

extension FixedBufferIOReader {

  @inlinable
  @inline(__always)
  mutating func read<T>(_ f: (UnsafePointer<UInt8>, Int) -> T) throws -> T {
    try withUnsafeTemporaryAllocation(of: UInt8.self, capacity: capacity) { buffer in
      let buffer = buffer.baseAddress!
      var current = 0
      buffer[current] = try .readHead()
      while !isASCIIWhitespaceOrNull(buffer[current]) {
        current += 1
        buffer[current] = nullIfEOF(getchar_unlocked())
      }
      return f(buffer, current)
    }
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
    _ f: (UnsafeBufferPointer<BufferElement>, Int) -> T?
  ) throws -> T {

    var current = 0
    buffer[current] = try .readHead()

    while !isASCIIWhitespaceOrNull(buffer[current]) {
      current += 1
      if current == buffer.count {
        buffer.append(nullIfEOF(getchar_unlocked()))
      } else {
        buffer[current] = nullIfEOF(getchar_unlocked())
      }
    }

    return try buffer.withUnsafeBufferPointer {
      try f($0, current).unwrap(or: Error.unexpectedNil)
    }
  }
}

@usableFromInline
protocol IOReaderInstance {
  associatedtype Element
  mutating func read() throws -> Element
  mutating func read() throws -> Item
  static var instance: Self { get set }
}

extension IOReaderInstance {

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
  public static func read<T>(_ f: (Element) -> T) throws -> (value: T, separator: UInt8) {
    let (a, b) = try instance.read()
    return (f(a), b)
  }
}

#if false
  @usableFromInline
  struct _atol: FixedBufferIOReader, IOReaderInstance {

    @usableFromInline
    typealias Element = Int

    @inlinable
    @inline(__always)
    var capacity: Int { 32 }

    @inlinable
    @inline(__always)
    public mutating func read() throws -> Element {
      try read { b, _ in atol(b) }
    }

    @inlinable
    @inline(__always)
    public mutating func read() throws -> Item {
      try read { b, c in (atol(b), b[c]) }
    }

    nonisolated(unsafe)
      public static var instance = Self()
  }
#else
  @usableFromInline
  struct _atol: ZeroBufferIOReader, IOReaderInstance {

    @usableFromInline
    typealias Element = Int

    @inlinable
    @inline(__always)
    var capacity: Int { 32 }

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

    nonisolated(unsafe)
      public static var instance = Self()
  }
#endif

@usableFromInline
struct _atof: FixedBufferIOReader, IOReaderInstance {

  @usableFromInline
  typealias Element = Double

  @inlinable
  @inline(__always)
  var capacity: Int { 64 }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    try read { b, _ in atof(b) }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try read { b, c in (atof(b), b[c]) }
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

@usableFromInline
struct _atob: VariableBufferIOReader, IOReaderInstance {

  @usableFromInline
  typealias Element = [UInt8]

  public var buffer: [UInt8] = [0]

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    try read { Array($0[0..<$1]) }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try read { b, c in
      (Array(b[0..<c]), b[c])
    }
  }

  @inlinable
  @inline(__always)
  static func read(count: Int) throws -> Element {
    defer { getchar_unlocked() }
    return try Array.readBytes(count: count)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}

@usableFromInline
struct _atos: VariableBufferIOReader, IOReaderInstance {

  @usableFromInline
  typealias Element = String

  public var buffer = [UInt8](repeating: 0, count: 32)

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {

    try read { b, c in String(bytes: b[0..<c], encoding: .ascii) }
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try read { b, c in
      String(
        bytes: b[0..<c],
        encoding: .ascii
      )
      .map {
        ($0, b[c])
      }
    }
  }

  @inlinable
  @inline(__always)
  static func read(count: Int) throws -> Element {
    defer { getchar_unlocked() }
    return try String(bytes: Array.readBytes(count: count), encoding: .ascii)
      .unwrap(or: Error.unexpectedNil)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}
