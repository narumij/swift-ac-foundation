import IOReader
import Pack

extension Pack3: SingleReadable where T: SingleReadable, U: SingleReadable, V: SingleReadable {

  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try .read(), try .read(), try .read())
  }
}
