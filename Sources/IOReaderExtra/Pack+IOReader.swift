import IOReader
import Pack

@available(macOS 14.0.0, *)
extension Pack: SingleReadable where repeat each T: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Pack<repeat each T> {
    .init(repeat try (each T).read())
  }
}
