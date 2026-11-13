import IOBase
import IOUtil

// MARK: -

extension UInt8: WordCharacter {

  public static func read() throws -> [UInt8] {
    try _atob.instance.read()
  }

  public static func wordIterator() -> LineIterator<[UInt8]> {
    makeLineIterator { try! _atob.instance.read() }
  }

  public static func wordIterator(columns: Int) -> AnyIterator<[UInt8]> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atob.instance.read() : nil
    }
  }
}

// MARK: -

extension UInt8 {

  public static var stdin: Self {
    try! _atob.read(count: 1).first!
  }

  public static func readLine() -> [UInt8] {
    try! withUnsafeReadLineBytes(strippingNewline: true) { $0.map { $0 } }
  }

  public static func readLine(columns: Int) -> [UInt8] {
    try! _atob.read(count: columns)
  }
}

extension UInt8: LineCharacter {}
