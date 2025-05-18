import Foundation

/// Array型に、文字列の配列に対する読み込み方法を加えるプロトコルです
///
/// 現在は以下の要素型に対して適用されています
///
/// 文字列: [Character], [UInt8]
///
/// 数値の場合とは異なり、columns引数は文字列の横幅の指定となります。
///
/// 入力例1
/// ```
/// ####
/// #..#
/// ####
/// ```
///
/// 読み込み例1
/// ```
/// String.stdin(rows: 3, columns: 4) // ["####","#..#","####"]
/// ```
public protocol AsciiArrayReadable {
  static func read() throws -> [Self]
  static func read(columns: Int) throws -> [Self]
  static func _readWithSeparator() throws -> (value: [Self], separator: UInt8)
}

extension Array where Element: AsciiArrayReadable {

  /// 標準入力から区切り無しの文字列を読み、配列で返します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print([UInt8].stdin) // [0x61, 0x62, 0x63, 0x64, 0x65]
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abc def
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print([UInt8].stdin, [UInt8].stdin) // [[0x61, 0x62, 0x63], [0x64, 0x65, 0x66]]
  /// ```
  ///
  /// 一行を読む場合、Swift.readline()が圧倒的に高速ですので、そちらをお勧めします。
  @inlinable
  @inline(__always)
  public static var stdin: [Element] {
    try! .read()
  }
  
  /// 標準入力から指定した長さの文字列を読み、配列で返します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print([UInt8].stdin(columns: 5)) // [0x61, 0x62, 0x63, 0x64, 0x65]
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abcdef
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print([UInt8].stdin(columns: 3), [UInt8].stdin(columns: 3)) // [[0x61, 0x62, 0x63], [0x64, 0x65, 0x66]]
  /// ```
  @inlinable
  @inline(__always)
  public static func stdin(columns: Int) -> [Element] {
    try! .read(columns: columns)
  }
}

extension Collection where Element: Collection, Element.Element: AsciiArrayReadable {
  
  /// 標準入力から文字列を指定した回数読み、配列の配列で返します
  ///
  /// 入力例1
  /// ```
  /// ####
  /// #..#
  /// ####
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// [UInt8].stdin(rows: 3) // [[0x23,0x23,0x23,0x23],[0x23,0x2e,0x2e,0x23],[0x23,0x23,0x23,0x23]]
  /// ```
  @inlinable
  @inline(__always)
  public static func stdin(rows: Int) -> [[Element.Element]] {
    try! .read(rows: rows)
  }
  
  /// 標準入力から指定した長さの文字列を指定した回数読み、配列の配列で返します
  ///
  /// 入力例1
  /// ```
  /// ####
  /// #..#
  /// ####
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// [UInt8].stdin(rows: 3, columns: 4) // ["####","#..#","####"]
  /// ```
  @inlinable
  @inline(__always)
  public static func stdin(rows: Int, columns: Int) -> [[Element.Element]] {
    try! .read(rows: rows, columns: columns)
  }
}


extension Array: SingleReadable where Element: AsciiArrayReadable {
  @inlinable
  @inline(__always)
  public static func read() throws -> [Element] {
    try Element.read()
  }
}

extension Array: LineReadable where Element: AsciiArrayReadable {
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: [Element], separator: UInt8) {
    try Element._readWithSeparator()
  }
}

extension Collection where Element: AsciiArrayReadable {
  
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [Element] {
    try Element.read(columns: columns)
  }
}

extension Array where Element: Collection, Element.Element: AsciiArrayReadable {

  @inlinable
  @inline(__always)
  public static func read(rows: Int) throws -> [[Element.Element]] {
    try (0..<rows).map { _ in try .read() }
  }

  @inlinable
  @inline(__always)
  public static func read(rows: Int, columns: Int) throws -> [[Element.Element]] {
    try (0..<rows).map { _ in try .read(columns: columns) }
  }
}

