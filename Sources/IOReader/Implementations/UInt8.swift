import Foundation

extension UInt8: AsciiReadable {}

extension UInt8 {

  /// ASCIIの先頭空白（SP・HT・LF・VT・FF・CR）を飛ばし、1バイトだけ読みます。
  /// C++のclassicロケールでの既定の `cin >> unsigned char` と同じ消費規則です。
  /// 後続の文字は消費しません。
  /// ロケールやストリームの書式フラグには対応しません。読める文字がなければ停止します。
  @inlinable
  @inline(__always)
  public static var cin: UInt8 {
    try! readCin()
  }

  /// `cin` の例外版。文字を読む前のEOFは `unexpectedEOF` になります。
  @inlinable
  @inline(__always)
  public static func readCin() throws -> UInt8 {
    while true {
      let c = getchar_unlocked()
      if c == -1 { throw IOReaderError.unexpectedEOF }
      if c == 0x20 || (0x09...0x0D).contains(c) { continue }
      return UInt8(c)
    }
  }
  
  /// Ascii Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> UInt8 {
    try _atob.read(count: 1).first.unwrap(or: IOReaderError.unexpectedNil)
  }
}

extension UInt8: AsciiArrayReadable {}

extension UInt8 {

  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> [UInt8] {
    try _atob.read()
  }
  
  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [UInt8] {
    try _atob.read(count: columns)
  }

  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: [UInt8], separator: UInt8) {
    try _atob.read()
  }
}
