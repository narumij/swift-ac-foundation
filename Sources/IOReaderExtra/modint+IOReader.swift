import AtCoder
import IOReader

extension static_modint: IOConversion, IOReader.Numeric {
  @inlinable
  public static func read() throws -> Self { .init(try readTuple() as Int) }
}

extension dynamic_modint: IOConversion, IOReader.Numeric {
  @inlinable
  public static func read() throws -> Self { .init(try readTuple() as Int) }
}
