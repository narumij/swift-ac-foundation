import Foundation

// MARK: - Reader

public protocol SingleRead {
  static func read() -> Self
  static func _read() throws -> Self
}

public protocol TupleRead: SingleRead {}
public protocol ArrayRead: SingleRead {}
public protocol FullRead: ArrayRead & TupleRead {}

extension Collection where Element: ArrayRead {
  @inlinable @inline(__always)
  public static func read(columns: Int) -> [Element] {
    (0..<columns).map { _ in Element.read() }
  }
  @inlinable @inline(__always)
  public static func read(rows: Int) -> [Element] {
    (0..<rows).map { _ in Element.read() }
  }
}

extension Collection where Element: Collection, Element.Element: ArrayRead {
  @inlinable @inline(__always)
  public static func read(rows: Int, columns: Int) -> [[Element.Element]] {
    (0..<rows).map { _ in Element.read(columns: columns) }
  }
}

extension Int: FullRead {}
extension UInt: FullRead {}
extension Double: FullRead {}
extension CInt: FullRead {}
extension CUnsignedInt: FullRead {}
extension CLongLong: FullRead {}
extension CUnsignedLongLong: FullRead {}

extension String: TupleRead {}
extension Character: TupleRead {}
extension UInt8: TupleRead {}

extension FixedWidthInteger {
  @inlinable @inline(__always)
  public static func read() -> Self { .init(try! ATOL.read()!) }
  @inlinable @inline(__always)
  public static func _read() throws -> Self { .init(try ATOL.read()!) }
}

extension BinaryFloatingPoint {
  @inlinable @inline(__always)
  public static func read() -> Self { .init(try! ATOF.read()!) }
  @inlinable @inline(__always)
  public static func _read() throws -> Self { .init(try ATOF.read()!) }
}

extension String {
  @inlinable @inline(__always)
  public static func read() -> String { ATOS.read() }
  @inlinable @inline(__always)
  public static func _read() throws -> String { ATOS.read() }

  @inlinable @inline(__always)
  public static func read(columns: Int) -> String { ATOS.read(columns: columns) }
}

extension Array where Element == String {
  @inlinable @inline(__always)
  public static func read(rows: Int) -> [String] {
    (0..<rows).map { _ in .read() }
  }
  @inlinable @inline(__always)
  public static func read(rows: Int, columns: Int) -> [String] {
    (0..<rows).map { _ in .read(columns: columns) }
  }
}

extension UInt8 {
  @inlinable
  public static func read() -> UInt8 { ATOB.read(columns: 1).first! }
  @inlinable
  public static func _read() throws -> UInt8 { ATOB.read(columns: 1).first! }
}

extension Array where Element == UInt8 {
  @inlinable @inline(__always)
  public static func read() -> [UInt8] { ATOB.read() }

  @inlinable @inline(__always)
  public static func _read() throws -> [UInt8] { ATOB.read() }

  @inlinable @inline(__always)
  public static func read(columns: Int) -> [UInt8] { ATOB.read(columns: columns) }
}

extension Array where Element == [UInt8] {
  @inlinable @inline(__always)
  public static func read(rows: Int) -> [[UInt8]] {
    (0..<rows).map { _ in .read() }
  }
  @inlinable @inline(__always)
  public static func read(rows: Int, columns: Int) -> [[UInt8]] {
    (0..<rows).map { _ in .read(columns: columns) }
  }
}

extension Character {
  @inlinable
  public static func read() -> Character { Character(String.read(columns: 1)) }
  @inlinable
  public static func _read() throws -> Character { Character(String.read(columns: 1)) }
}

extension Array where Element == Character {
  @inlinable @inline(__always)
  public static func read() -> [Character] {
    String.read().map { $0 }
  }
  @inlinable @inline(__always)
  public static func _read() throws -> [Character] {
    String.read().map { $0 }
  }
  @inlinable @inline(__always)
  public static func read(columns: Int) -> [Character] {
    String.read(columns: columns).map { $0 }
  }
}

extension Array where Element == [Character] {
  @inlinable @inline(__always)
  public static func read(rows: Int) -> [[Character]] {
    (0..<rows).map { _ in .read() }
  }
  @inlinable @inline(__always)
  public static func read(rows: Int, columns: Int) -> [[Character]] {
    (0..<rows).map { _ in .read(columns: columns) }
  }
}

@usableFromInline
enum IOReaderError: Swift.Error {
  case unexpectedEOF
}

@usableFromInline protocol IOReader {}

@usableFromInline protocol FixedBufferIOReader: IOReader {
  var buffer: [UInt8] { get set }
}

extension FixedWidthInteger {
  @inlinable @inline(__always) static var SP: Self { 0x20 }
  @inlinable @inline(__always) static var LF: Self { 0x0A }
}

extension FixedWidthInteger {

  @inlinable @inline(__always)
  static func __readHead() -> Self {
    var head: Self
    repeat {
      head = numericCast(getchar_unlocked())
    } while head == .SP || head == .LF
    return head
  }
}

extension Array where Element: FixedWidthInteger {

  @inlinable @inline(__always)
  static func __readBytes(count: Int) -> Self? {
    let h: Element = .__readHead()
    guard h != EOF else { return nil }
    return [h] + (1..<count).map { _ in numericCast(getchar_unlocked()) }
  }
}

extension FixedBufferIOReader {

  @inlinable @inline(__always)
  mutating func _next<T>(_ f: (UnsafePointer<UInt8>) -> T) throws -> T? {
    var current = 0
    return try buffer.withUnsafeMutableBufferPointer { buffer in
      buffer.baseAddress![current] = .__readHead()
      while buffer.baseAddress![current] != .SP,
        buffer.baseAddress![current] != .LF,
        buffer.baseAddress![current] != EOF
      {
        current += 1
        let c = getchar_unlocked()
        if c == -1 {
          throw IOReaderError.unexpectedEOF
        }
        buffer[current] = numericCast(c)
      }
      return current == 0 ? nil : f(buffer.baseAddress!)
    }
  }
}

@usableFromInline protocol VariableBufferIOReader: IOReader {
  associatedtype BufferElement: FixedWidthInteger
  var buffer: [BufferElement] { get set }
}

extension VariableBufferIOReader {
  @inlinable @inline(__always)
  mutating func _next<T>(_ f: (UnsafeBufferPointer<BufferElement>, Int) -> T?) -> T? {
    var current = 0
    buffer[current] = .__readHead()
    while buffer[current] != .SP, buffer[current] != .LF, buffer[current] != 0 {
      current += 1
      if current == buffer.count {
        buffer.append(contentsOf: repeatElement(0, count: buffer.count))
      }
      buffer[current] = BufferElement(truncatingIfNeeded: getchar_unlocked())
    }
    return buffer.withUnsafeBufferPointer { f($0, current) }
  }
}

@usableFromInline
protocol IOReaderInstance: IteratorProtocol {
  static var instance: Self { get set }
}

extension IOReaderInstance {
  @inlinable @inline(__always) static func read() -> Element! { instance.next() }
}

@usableFromInline
protocol IOReaderInstance2 {
  associatedtype Element
  mutating func next() throws -> Self.Element?
  static var instance: Self { get set }
}

extension IOReaderInstance2 {
  @inlinable @inline(__always) static func read() throws -> Element! { try instance.next() }
}

@usableFromInline struct ATOL: FixedBufferIOReader, IOReaderInstance2 {
  public var buffer = [UInt8](repeating: 0, count: 32)
  @inlinable @inline(__always)
  public mutating func next() throws -> Int? { try _next { atol($0) } }
  public static var instance = Self()
}

@usableFromInline struct ATOF: FixedBufferIOReader, IOReaderInstance2 {
  public var buffer = [UInt8](repeating: 0, count: 64)
  @inlinable @inline(__always)
  public mutating func next() throws -> Double? { try _next { atof($0) } }
  public static var instance = Self()
}

@usableFromInline struct ATOB: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
  public var buffer: [UInt8] = .init(repeating: 0, count: 32)
  @inlinable @inline(__always)
  public mutating func next() -> [UInt8]? { _next { Array($0[0..<$1]) } }
  public static var instance = Self()
  @inlinable @inline(__always) static func read(columns: Int) -> [UInt8] {
    defer { getchar_unlocked() }
    return .__readBytes(count: columns) ?? []
  }
}

@usableFromInline struct ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
  public var buffer = [UInt8](repeating: 0, count: 32)
  @inlinable @inline(__always)
  public mutating func next() -> String? {
    _next { b, c in String(bytes: b[0..<c], encoding: .ascii) }
  }
  public static var instance = Self()
  @inlinable @inline(__always) static func read(columns: Int) -> String! {
    defer { getchar_unlocked() }
    return String(bytes: Array.__readBytes(count: columns) ?? [], encoding: .ascii)
  }
}
