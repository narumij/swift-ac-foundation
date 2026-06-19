import IOReader
import Pack

extension Pack2: SingleReadable where T: SingleReadable, U: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try .read(), try .read())
  }
}
