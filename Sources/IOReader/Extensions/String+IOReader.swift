import IOBase

// MARK: - 単語系統

extension String {

  /// 標準入力から空白で区切られた文字列を1つ読み、返します
  ///
  /// 入力例
  /// ```
  /// abc def
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print(String.stdin, String.stdin) // abc def
  /// ```
  @inlinable
  public static var stdin: String {
    valuePreservingSeparator(try! read())
  }
}

extension Array where Element == String {

  /// 標準入力から1行分の、空白で区切られた文字列を読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// abc def
  /// ghi
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([String].stdin()) // ["abc", "def"]
  /// print([String].stdin()) // ["ghi"]
  /// ```
  @inlinable
  public static func stdin() -> [String] {
    Array(LineIterator<String>(read: _atos.read))
  }

  /// 標準入力から空白で区切られた文字列を指定した個数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// a bc def
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([String].stdin(columns: 3)) // ["a", "bc", "def"]
  /// ```
  @inlinable
  public static func stdin(columns: Int) -> [String] {
    Array(String.wordIterator(columns: columns))
  }
}

extension Array where Element == [String] {

  /// 標準入力から指定した行数を読み、各行の空白で区切られた文字列を2次元配列で返します
  ///
  /// 各行は `[String].stdin()` と同じく、1行分の文字列を読みます。
  ///
  /// 入力例
  /// ```
  /// abc def
  /// ghi
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[String]].stdin(rows: 2)) // [["abc", "def"], ["ghi"]]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [[String]] {
    (0..<rows).map { _ in .stdin() }
  }

  /// 標準入力から指定した行数と列数の、空白で区切られた文字列を読み、2次元配列で返します
  ///
  /// 各行の最後の文字列の直後が改行でない場合は停止します。
  ///
  /// 入力例
  /// ```
  /// a b
  /// c d
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[String]].stdin(rows: 2, columns: 2)) // [["a", "b"], ["c", "d"]]
  /// ```
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [[String]] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}

// MARK: - 行系統

extension String {

  /// 標準入力から1行を読み、改行を除いて返します
  ///
  /// 空白も含めて、行をそのまま返します。
  ///
  /// 入力例
  /// ```
  /// abc def
  /// ghi
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print(String.readLine()) // abc def
  /// print(String.readLine()) // ghi
  /// ```
  @inlinable
  public static func readLine() -> String {
    try! withUnsafeReadLineBytes(strippingNewline: true) { String(decoding: $0, as: UTF8.self) }
  }

  /// 標準入力から指定した長さの文字列を読み、返します
  ///
  /// 入力例
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print(String.stdin(columns: 3), String.stdin(columns: 2)) // abc de
  /// ```
  @inlinable
  public static func stdin(columns: Int) -> String {
    try! _atos.read(count: columns)
  }
}

extension Array where Element == String {

  /// 標準入力から指定した行数を読み、配列で返します
  ///
  /// 各行は ``String/readLine()`` と同じく、空白も含めてそのまま返します。
  ///
  /// 入力例
  /// ```
  /// a b
  /// c d
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([String].stdin(rows: 2)) // ["a b", "c d"]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [String] {
    (0..<rows).map { _ in .readLine() }
  }

  /// 標準入力から指定した長さの文字列を指定した行数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// ####
  /// #..#
  /// ####
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([String].stdin(rows: 3, columns: 4)) // ["####", "#..#", "####"]
  /// ```
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [String] {
    (0..<rows).map { _ in
      let line = String.stdin(columns: columns)
      let separator: UInt8? = __getchar_unlocked()
      precondition(isNilOrAsciiNewLine(separator), "the line has more characters than the columns: read \(line.debugDescription), next \(describeByte(separator))")
      return line
    }
  }
}

// MARK: -

extension String: Component {}

extension String: Word {

  @inlinable
  public static func read() throws -> (value: String, separator: UInt8?) {
    try _atos.instance.read()
  }
}

