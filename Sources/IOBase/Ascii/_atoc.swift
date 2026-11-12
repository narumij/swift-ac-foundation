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
  mutating func _read() throws -> Item {
    buffer.removeAll(keepingCapacity: true)
    var current: UInt8? = try .readHead()
    while let c = current, !isASCIIWhitespace(c) {
      buffer.append(Character(UnicodeScalar(c)))
      current = __getchar_unlocked()
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
    for i in 0..<count {
      guard let lastByte: UInt8 = i == 0 ? try UInt8.readHead() : __getchar_unlocked() else {
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
