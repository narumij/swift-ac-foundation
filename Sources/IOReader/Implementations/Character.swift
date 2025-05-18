import Foundation

extension Character: AsciiArrayReadable {}

// MARK: - Ascii Array Readable

extension Character {

  /// 標準入力からASCII文字を1文字読みます
  ///
  /// 以下を想定しています。
  /// ```
  /// A B C
  /// ```
  ///
  /// ```
  /// let c1 = Character.stdin // "A"
  /// let c2 = Character.stdin // "B"
  /// let c3 = Character.stdin // "C"
  /// ```
  ///
  /// 文字種を問わずデリミタを強制で消費するため、以下の様な場合には注意が必要です
  ///
  /// ```
  /// ABCDE
  /// ```
  ///
  /// ```
  /// let c1 = Character.stdin // "A"
  /// let c2 = Character.stdin // "C"
  /// let c3 = Character.stdin // "E"
  /// ```
  @inlinable
  public static var stdin: Self {
    try! read()
  }
}

extension Array where Element == Character {

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print([Character].stdin) // ["a","b","c","d","e"]
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abc def
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print([Character].stdin, [Character].stdin) // ["a","b","c"] ["d","e","f"]
  /// ```
  ///
  /// 区切りがない一行を読む場合、Swift.readline()が圧倒的に高速ですので、そちらをお勧めします。
  @inlinable
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
  /// print([Character].stdin(columns: 5)) // ["a","b","c","d","e"]
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abcdef
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print([Character].stdin(columns: 3), [Character].stdin(columns: 3)) // [["a","b","c"],["d","e","f"]]
  /// ```
  @inlinable
  public static func stdin(columns: Int) -> [Character] {
    try! read(columns: columns)
  }
}

extension Array where Element == [Character] {

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
  /// [Character].stdin(rows: 3) // [["#","#","#","#"],["#",".",".","#"],["#","#","#","#"]]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [[Character]] {
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
  /// [Character].stdin(rows: 3, columns: 4) // [["#","#","#","#"],["#",".",".","#"],["#","#","#","#"]]
  /// ```
  ///
  /// 入力側の文字列がcolumn引数より長い場合、残りの文字は標準入力に残したままとなり、次の読み込みの際に使われます
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [[Character]] {
    try! read(rows: rows, columns: columns)
  }
}

// MARK: - Implementation

extension Character {
  
  /// Single Readable
  @inlinable
  public static func read() throws -> Character {
    try Character(String.read(columns: 1))
  }
}

extension Array where Element == Character {
  
  /// Ascii Array Readable
  @inlinable
  public static func read() throws -> [Character] {
    try _atos.read { $0.map { $0 } }.value
  }
  
  /// Ascii Array Line Readable
  @inlinable
  public static func _readWithSeparator() throws -> (value: [Character], separator: UInt8) {
    try _atos.read { $0.map { $0 } }
  }
}

// MARK: -

extension Array where Element == Character {
  
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [Character] {
    try _atos.read(count: columns).map { $0 }
  }
}

extension Array where Element == [Character] {

  @inlinable
  @inline(__always)
  public static func read(rows: Int) throws -> [[Character]] {
    try (0..<rows).map { _ in try .read() }
  }

  @inlinable
  @inline(__always)
  public static func read(rows: Int, columns: Int) throws -> [[Character]] {
    try (0..<rows).map { _ in try .read(columns: columns) }
  }
}
