import _FastIO

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
