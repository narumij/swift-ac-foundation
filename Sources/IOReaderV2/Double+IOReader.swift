import IOBase

extension Double: Numeric {

  public static func read() throws -> Double {
    try _atof.read()
  }

  public static func lineIterator() -> LineIterator<Double> {
    makeLineIterator { try! _atof.read() }
  }

  public static func lineIterator(columns: Int) -> AnyIterator<Double> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atof.read() : nil
    }
  }
}
