import Foundation

@usableFromInline
package struct _atos: VariableBufferIOReader, InstanceIOReader {

  @usableFromInline
  package typealias Element = String

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

    try read { (b: [UInt8], c: UInt8?) in
      String(
        bytes: b,
        encoding: .ascii
      ).map { ($0, c) }
    }
  }

  @inlinable
  @inline(__always)
  package static func read(count: Int) throws -> Element {
    return try String(bytes: instance.readBytes(count: count), encoding: .ascii)
      .unwrap(or: IOReaderError.unexpectedNil)
  }

  nonisolated(unsafe)
    public static var instance = Self()
}
