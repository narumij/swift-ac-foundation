import _FastIO

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
