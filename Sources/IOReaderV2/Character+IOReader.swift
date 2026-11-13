import IOBase
import IOUtil

// MARK: -

extension Character: WordCharacter {

  public static func _readWithSeparator() throws -> (value: [Character], separator: UInt8?) {
    try _atoc.instance.read()
  }
}

// MARK: -

extension Character {

  public static var stdin: Self {
    try! _atoc.read(count: 1).first!
  }

  public static func readLine() -> [Character] {
    try! withUnsafeReadLineBytes(strippingNewline: true) { $0.map { Character(UnicodeScalar($0)) } }
  }

  public static func readLine(columns: Int) -> [Character] {
    try! _atoc.read(count: columns)
  }
}

extension Character: Component {}
extension Character: LineCharacter {}
