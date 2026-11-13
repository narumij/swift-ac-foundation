import IOBase

#if false
// MARK: - 単語系統

extension Sequence where Element == UInt8 {
  
  public static var stdin: [UInt8] {
    try! _atob.read()
  }
}

extension Array where Element == [UInt8] {

  /// 標準入力から1行分の、空白で区切られたバイト列を読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// ab c
  /// d
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[UInt8]].stdin()) // [[97, 98], [99]]
  /// print([[UInt8]].stdin()) // [[100]]
  /// ```
  public static func stdin() -> [[UInt8]] {
    Array(makeLineIterator(_atob.read))
  }

  /// 標準入力から空白で区切られたバイト列を指定した個数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// a bc
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[UInt8]].stdin(columns: 2)) // [[97], [98, 99]]
  /// ```
  public static func stdin(columns: Int) -> [[UInt8]] {
    (0..<columns).map { _ in try! _atob.read() }
  }
}

// MARK: - 行系統

extension Array where Element == UInt8 {

  /// 標準入力から1行を読み、改行を除いてバイト列で返します
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
  /// print([UInt8].readLine()) // [97, 32, 98]
  /// print([UInt8].readLine()) // [99]
  /// ```
  public static func readLine() -> [UInt8] {
    Array(Swift.readLine()!.utf8)
  }

  /// 標準入力から指定した長さのバイト列を読み、返します
  ///
  /// 入力例
  /// ```
  /// abc
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([UInt8].stdin(columns: 2), [UInt8].stdin(columns: 1)) // [97, 98] [99]
  /// ```
  public static func stdin(columns: Int) -> [UInt8] {
    try! _atob.read(count: columns)
  }
}

extension Array where Element == [UInt8] {

  /// 標準入力から指定した行数を読み、バイト列の配列で返します
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
  /// print([[UInt8]].stdin(rows: 2)) // [[97, 32, 98], [99]]
  /// ```
  public static func stdin(rows: Int) -> [[UInt8]] {
    (0..<rows).map { _ in .readLine() }
  }

  /// 標準入力から指定した長さのバイト列を指定した行数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// #.
  /// .#
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[UInt8]].stdin(rows: 2, columns: 2)) // [[35, 46], [46, 35]]
  /// ```
  public static func stdin(rows: Int, columns: Int) -> [[UInt8]] {
    (0..<rows).map { _ in
      let line = [UInt8].stdin(columns: columns)
      let separator: UInt8? = __getchar_unlocked()
      precondition(isNilOrAsciiNewLine(separator))
      return line
    }
  }
}
#endif
