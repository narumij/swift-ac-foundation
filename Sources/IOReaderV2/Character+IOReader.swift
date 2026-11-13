import IOBase

#if false
// MARK: - 単語系統

extension Sequence where Element == Character {
  
  public static var stdin: [Character] {
    try! _atoc.read()
  }
}

//extension Array where Element == Character {
//  
//  public static var stdin: [Character] {
//    try! _atoc.read()
//  }
//}

extension Array where Element == [Character] {

  /// 標準入力から1行分の、空白で区切られた文字の列を読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// ab c
  /// d
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[Character]].stdin()) // [["a", "b"], ["c"]]
  /// print([[Character]].stdin()) // [["d"]]
  /// ```
//  public static func stdin() -> [[Character]] {
//    Array(makeLineIterator(_atoc.read))
//  }

  /// 標準入力から空白で区切られた文字の列を指定した個数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// a bc
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[Character]].stdin(columns: 2)) // [["a"], ["b", "c"]]
  /// ```
  public static func stdin(columns: Int) -> [[Character]] {
    (0..<columns).map { _ in try! _atoc.read() }
  }
}

// MARK: - 行系統

extension Array where Element == Character {

  /// 標準入力から1行を読み、改行を除いて文字の配列で返します
  ///
  /// 空白も含めて、行をそのまま返します。
  ///
  /// 入力例
  /// ```
  /// a b
  /// c
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([Character].readLine()) // ["a", " ", "b"]
  /// print([Character].readLine()) // ["c"]
  /// ```
  public static func readLine() -> [Character] {
    Array(Swift.readLine()!)
  }

  /// 標準入力から指定した長さの文字の列を読み、返します
  ///
  /// 入力例
  /// ```
  /// abc
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([Character].stdin(columns: 2), [Character].stdin(columns: 1)) // ["a", "b"] ["c"]
  /// ```
  public static func stdin(columns: Int) -> [Character] {
    try! _atoc.read(count: columns)
  }
}

extension Array where Element == [Character] {

  /// 標準入力から指定した行数を読み、文字の配列の配列で返します
  ///
  /// 各行は ``Swift/Array/readLine()`` と同じく、空白も含めてそのまま返します。
  ///
  /// 入力例
  /// ```
  /// a b
  /// c
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[Character]].stdin(rows: 2)) // [["a", " ", "b"], ["c"]]
  /// ```
  public static func stdin(rows: Int) -> [[Character]] {
    (0..<rows).map { _ in .readLine() }
  }

  /// 標準入力から指定した長さの文字の列を指定した行数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// #.
  /// .#
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[Character]].stdin(rows: 2, columns: 2)) // [["#", "."], [".", "#"]]
  /// ```
  public static func stdin(rows: Int, columns: Int) -> [[Character]] {
    (0..<rows).map { _ in
      let line = [Character].stdin(columns: columns)
      let separator: UInt8? = __getchar_unlocked()
      precondition(isNilOrAsciiNewLine(separator))
      return line
    }
  }
}
#endif
