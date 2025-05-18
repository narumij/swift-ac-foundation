import Foundation

extension UInt8: AsciiArrayReadable {}

// MARK: - Ascii Array Readable

extension UInt8 {

  /// 標準入力からASCII文字を1文字読みます
  ///
  /// 以下を想定しています。
  /// ```
  /// A B C
  /// ```
  ///
  /// ```
  /// let c1 = UInt8.stdin // "A"
  /// let c2 = UInt8.stdin // "B"
  /// let c3 = UInt8.stdin // "C"
  /// ```
  ///
  /// 文字種を問わずデリミタを強制で消費するため、以下の様な場合には注意が必要です
  ///
  /// ```
  /// ABCDE
  /// ```
  ///
  /// ```
  /// let c1 = UInt8.stdin // "A"
  /// let c2 = UInt8.stdin // "C"
  /// let c3 = UInt8.stdin // "E"
  /// ```
  @inlinable
  @inline(__always)
  public static var stdin: Self {
    try! read()
  }
}

extension Array where Element == UInt8 {

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得します
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
  /// 区切りがない一行を読む場合、Swift.readline()が圧倒的に高速ですので、そちらをお勧めします。
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
  public static func stdin(columns: Int) -> [UInt8] {
    try! read(columns: columns)
  }
}

extension Array where Element == [UInt8] {

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
  /// [UInt8].stdin(rows: 3) // [[0x23,0x23,0x23,0x23],[0x23,0x2e,0x2e,0x23],[0x23,0x23,0x23,0x23]]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [[UInt8]] {
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
  /// [UInt8].stdin(rows: 3, columns: 4) // ["####","#..#","####"]
  /// ```
  ///
  /// 入力側の文字列がcolumn引数より長い場合、残りの文字は標準入力に残したままとなり、次の読み込みの際に使われます
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [[UInt8]] {
    try! read(rows: rows, columns: columns)
  }
}

// MARK: - Implementation

extension UInt8 {
  
  /// Single Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> UInt8 {
    try _atob.read(count: 1).first.unwrap(or: Error.unexpectedNil)
  }
}

extension Array where Element == UInt8 {

  /// Single Readable
  @inlinable
  @inline(__always)
  public static func read() throws -> [UInt8] {
    try _atob.read()
  }
  
  /// Ascii Array Line Readable
  @inlinable
  @inline(__always)
  public static func _readWithSeparator() throws -> (value: [UInt8], separator: UInt8) {
    try _atob.read()
  }
}

// MARK: -

extension Array where Element == UInt8 {
  
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [UInt8] {
    try _atob.read(count: columns)
  }
}

extension Array where Element == [UInt8] {

  @inlinable
  @inline(__always)
  public static func read(rows: Int) throws -> [[UInt8]] {
    try (0..<rows).map { _ in try .read() }
  }

  @inlinable
  @inline(__always)
  public static func read(rows: Int, columns: Int) throws -> [[UInt8]] {
    try (0..<rows).map { _ in try .read(columns: columns) }
  }
}

