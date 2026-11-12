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
    _ f: ([BufferElement], BufferElement?) -> T?
  ) throws -> T {
    buffer.removeAll(keepingCapacity: true)
    var current: BufferElement? = try BufferElement.readHead()
    while let c = current, !isASCIIWhitespace(c) {
      buffer.append(c)
      current = __getchar_unlocked()
    }
    defer { resetBufferIfNeeded() }
    return try f(buffer, current).unwrap(or: IOReaderError.unexpectedNil)
  }

  @inlinable
  @inline(__always)
  mutating func readBytes(count: Int) throws -> [BufferElement] {
    buffer.removeAll(keepingCapacity: true)
    for i in 0..<count {
      guard let lastByte: BufferElement = i == 0 ? try BufferElement.readHead() : __getchar_unlocked() else {
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
