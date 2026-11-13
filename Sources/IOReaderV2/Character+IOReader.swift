import IOBase
import IOUtil

// MARK: -

extension Character: WordCharacter {

  public static func read() throws -> [Character] {
    try _atoc.instance.read()
  }

  public static func wordIterator() -> LineIterator<[Character]> {
    makeLineIterator { try! _atoc.instance.read() }
  }

  public static func wordIterator(columns: Int) -> AnyIterator<[Character]> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! _atoc.instance.read() : nil
    }
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
