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
    try _atos.read { $0.map { $0 } }.value
  }
  
  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [Character] {
    try _atos.read(count: columns).map { $0 }
  }

  /// Ascii Array Readable
  @inlinable
  public static func _readWithSeparator() throws -> (value: [Character], separator: UInt8) {
    try _atos.read { $0.map { $0 } }
  }
}

