import BigInt
import IOReader

extension BigInt: IOConversion, IOReader.Numeric {
  @inlinable
  public static func read() throws -> Self { .init(try readTuple() as String)! }
}
