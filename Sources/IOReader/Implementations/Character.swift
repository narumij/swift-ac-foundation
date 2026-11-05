import Foundation

extension Character: AsciiReadable {}

extension Character {

  /// ASCIIの先頭空白を飛ばし、1文字だけ読みます。後続の文字は消費しません。
  /// C++の既定の `cin >> char` に相当するASCII入力用の入口です。
  /// 読める文字がなければ停止します。Unicodeの文字単位の読取りには対応しません。
  @inlinable
  @inline(__always)
  public static var cin: Character {
    try! readCin()
  }

  /// `cin` の例外版。空白とEOFの扱いは `UInt8.readCin()` と同じです。
  @inlinable
  @inline(__always)
  public static func readCin() throws -> Character {
    try Character(UnicodeScalar(UInt8.readCin()))
  }
  
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
    try _atoc.read()
  }
  
  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [Character] {
    try _atoc.read(count: columns)
  }

  /// Ascii Array Readable
  @inlinable
  public static func _readWithSeparator() throws -> (value: [Character], separator: UInt8) {
    try _atoc.read()
  }
}

