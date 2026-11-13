import IOBase
import IOUtil

// MARK: -

extension UInt8: WordCharacter {

  public static func _readWithSeparator() throws -> (value: [UInt8], separator: UInt8?) {
    try _atob.instance.read()
  }
}

// MARK: -

extension UInt8 {

  public static var stdin: Self {
    try! _atob.read(count: 1).first!
  }

  public static func _readWithSeparator() throws -> (value: UInt8, separator: UInt8?) {
    (try _atob.read(count: 1).first!, __getchar_unlocked())
  }

  public static func readLine() -> [UInt8] {
    try! withUnsafeReadLineBytes(strippingNewline: true) { $0.map { $0 } }
  }

  public static func readLine(columns: Int) -> [UInt8] {
    try! _atob.read(count: columns)
  }
}

extension UInt8: Component {}
extension UInt8: LineCharacter {}
