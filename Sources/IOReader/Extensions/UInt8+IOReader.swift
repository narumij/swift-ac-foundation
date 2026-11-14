import IOBase

// MARK: -

extension UInt8: WordCharacter {

  @inlinable
  public static func _readWithSeparator() throws -> (value: [UInt8], separator: UInt8?) {
    try _atob.instance.read()
  }
}

// MARK: -

extension UInt8 {

  @inlinable
  public static var stdin: Self {
    try! _atob.read(count: 1).first!
  }

  @inlinable
  public static func _readWithSeparator() throws -> (value: UInt8, separator: UInt8?) {
    (try _atob.read(count: 1).first!, __getchar_unlocked())
  }

  @inlinable
  public static func readLine() -> [UInt8] {
    try! withUnsafeReadLineBytes(strippingNewline: true) { $0.map { $0 } }
  }

  @inlinable
  public static func readLine(columns: Int) -> [UInt8] {
    try! _atob.read(count: columns)
  }
}

extension UInt8: Component {}
extension UInt8: LineCharacter {}
