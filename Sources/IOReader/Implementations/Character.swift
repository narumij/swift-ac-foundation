import Foundation

extension Character: AsciiReadable {}

extension Character {
  
  /// Single Readable
  @inlinable
  public static func read() throws -> Character {
    try Character(String.read(columns: 1))
  }
}

extension Character: AsciiArrayReadable {}

extension Character {
  
  /// Ascii Array Readable
  @inlinable
  public static func read() throws -> [Character] {
    try _atob.read().map { Character(UnicodeScalar($0)) }
  }
  
  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [Character] {
    try _atob.read(count: columns).map { Character(UnicodeScalar($0)) }
  }

  /// Ascii Array Readable
  @inlinable
  public static func _readWithSeparator() throws -> (value: [Character], separator: UInt8) {
    let (buf, sep) = try _atob.read()
    return (buf.map { Character(UnicodeScalar($0)) }, sep)
  }
}

