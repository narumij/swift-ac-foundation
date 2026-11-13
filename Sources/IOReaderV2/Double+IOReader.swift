import IOBase

extension BinaryFloatingPoint {
  
  public static func read() throws -> Self {
    .init(try _atof.read())
  }

  public static func lineIterator() -> FloatingPointLineIterator<Self> {
    makeFloatingPointLineIterator { try! _atof.read() }
  }

  public static func lineIterator(columns: Int) -> AnyIterator<Self> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? .init(try! _atof.read()) : nil
    }
  }
}

extension Float: Numeric {}
extension Double: Numeric {}
