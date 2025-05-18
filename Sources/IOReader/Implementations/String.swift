import Foundation

extension String: AsciiArrayReadable & LineReadable {}

// MARK: - Ascii Array Readable

extension String {

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(String.stdin) // abcde
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abc def
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(String.stdin, String.stdin) // abc def
  /// ```
  ///
  /// 区切りがなく、一行を読む場合、Swift.readline()が圧倒的に高速ですので、そちらをお勧めします。
  @inlinable
  @inline(__always)
  public static var stdin: Self {
    try! read()
  }

  /// 標準入力から空白や改行以外の文字列を文字数を指定して取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(String.stdin(columns: 5)) // abcde
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abcdef
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(String.stdin(columns: 3), String.stdin(columns: 3)) // abc def
  /// ```
  @inlinable
  public static func stdin(columns: Int) -> String {
    try! read(columns: columns)
  }
}

extension Array where Element == String {

  /// 標準入力から空白や改行以外の文字列を行ごとに取得します
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
  /// String.stdin(rows: 3) // ["####","#..#","####"]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [String] {
    try! read(rows: rows)
  }

  /// 標準入力から空白や改行以外の文字列を文字数を指定し、行ごとに取得します
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
  ///
  /// 入力側の文字列がcolumn引数より長い場合、残りの文字は標準入力に残したままとなり、次の読み込みの際に使われます
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [String] {
    try! read(rows: rows, columns: columns)
  }
}

// MARK: - Implementation

extension String {
  
  /// Ascii Array Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    try _atos.read()
  }
  
  /// Ascii Array Line Readable
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: String, separator: UInt8) {
    try _atos.read()
  }
}

extension String {
  
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> String {
    try _atos.read(count: columns)
  }
}

extension Array where Element == String {

  @inlinable
  @inline(__always)
  public static func read(rows: Int) throws -> [String] {
    try (0..<rows).map { _ in try .read() }
  }

  @inlinable
  @inline(__always)
  public static func read(rows: Int, columns: Int) throws -> [String] {
    try (0..<rows).map { _ in try .read(columns: columns) }
  }
}
