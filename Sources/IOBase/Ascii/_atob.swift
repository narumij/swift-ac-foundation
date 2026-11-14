
@usableFromInline
package struct _atob: VariableBufferIOReader, InstanceIOReader {

  @usableFromInline
  package typealias Element = [UInt8]

  public var buffer: [UInt8] = {
    var b = [UInt8]()
    b.reserveCapacity(IOConfig.bufferPolicy.minCapacity)
    return b
  }()

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try read { b, c in
      (b, c)
    }
  }

  @inlinable
  @inline(__always)
  package static func read(count: Int) throws -> Element {
    return try instance.readBytes(count: count)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}
