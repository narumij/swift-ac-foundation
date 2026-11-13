import IOBase

extension UInt: Numeric {

  public static func read() throws -> UInt {
    try _atoul<UInt>.read()
  }

  public static func lineIterator() -> LineIterator<UInt> {
    makeLineIterator { try! _atoul<UInt>.read() }
  }

  public static func lineIterator(columns: Int) -> AnyIterator<UInt> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atoul<UInt>.read() : nil
    }
  }
}
