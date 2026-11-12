import IOStream

extension Int {

  /// 標準入力から整数を1つ読み、返します
  ///
  /// 入力例
  /// ```
  /// 1 -2
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print(Int.stdin, Int.stdin) // 1 -2
  /// ```
  public static var stdin: Int {
    try! _atol<Int>.read()
  }
}

extension Array where Element == Int {

  /// 標準入力から1行分の整数を読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// 1 2 3
  /// 4
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([Int].stdin()) // [1, 2, 3]
  /// print([Int].stdin()) // [4]
  /// ```
  public static func stdin() -> [Int] {
    Array(makeLineIterator(_atol<Int>.read))
  }

  /// 標準入力から縦に並んだ整数を指定した個数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// 1
  /// 2
  /// 3
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([Int].stdin(rows: 3)) // [1, 2, 3]
  /// ```
  public static func stdin(rows: Int) -> [Int] {
    (0..<rows).map { _ in .stdin }
  }

  /// 標準入力から横に並んだ整数を指定した個数読み、配列で返します
  ///
  /// 入力例
  /// ```
  /// 1 2 3
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([Int].stdin(columns: 3)) // [1, 2, 3]
  /// ```
  public static func stdin(columns: Int) -> [Int] {
    (0..<columns).map { _ in .stdin }
  }
}

extension Array where Element == [Int] {

  /// 標準入力から指定した行数を読み、各行の整数を2次元配列で返します
  ///
  /// 各行は `[Int].stdin()` と同じく、1行分の整数を読みます。
  ///
  /// 入力例
  /// ```
  /// 1 2 3
  /// 4
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[Int]].stdin(rows: 2)) // [[1, 2, 3], [4]]
  /// ```
  public static func stdin(rows: Int) -> [[Int]] {
    (0..<rows).map { _ in .stdin() }
  }

  /// 標準入力から指定した行数と列数の整数を読み、2次元配列で返します
  ///
  /// 入力例
  /// ```
  /// 1 2 3
  /// 4 5 6
  /// ```
  ///
  /// 読み込み例
  /// ```
  /// print([[Int]].stdin(rows: 2, columns: 3)) // [[1, 2, 3], [4, 5, 6]]
  /// ```
  public static func stdin(rows: Int, columns: Int) -> [[Int]] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}
