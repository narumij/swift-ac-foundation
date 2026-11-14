import IOBase

public protocol IOConversion {
  static func read() throws -> Self
}

extension IOConversion {

  @inlinable
  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    (try read(), __getchar_unlocked())
  }

  @inlinable
  public static func readTuple<each T: Component>() throws -> (repeat each T) {
    try _readGroupElements()
  }
}
