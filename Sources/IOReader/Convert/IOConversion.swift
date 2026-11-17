import IOBase

public protocol IOConversion {
  static func read() throws -> (value: Self, separator: UInt8?)
}

extension IOConversion {

  @inlinable
  public static func readTuple<each T: Component, S>(_ f: ((repeat each T)) -> S) throws -> (value: S, separator: UInt8?) {
    try _readTuple(f)
  }
}
