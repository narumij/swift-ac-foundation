import IOBase

extension FixedWidthInteger where Self: UnsignedInteger {

  public static func read() throws -> Self {
    try _atoul<Self>.read()
  }

  public static func lineIterator() -> LineIterator<Self> {
    makeLineIterator { try! _atoul<Self>.read() }
  }

  public static func lineIterator(columns: Int) -> AnyIterator<Self> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atoul<Self>.read() : nil
    }
  }
}

extension UInt: Numeric {}
extension UInt64: Numeric {}
extension UInt32: Numeric {}
extension UInt16: Numeric {}
