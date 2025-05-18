import Foundation

/// Array型に、数値の配列に対する読み込み方法を加えるプロトコルです
///
/// 現在は以下の要素型に対して適用されています
///
/// 整数: Int, UInt, CInt, CUnsignedInt, CLongLong, CUnsignedLongLong
///
/// 浮動小数: Double
///
/// 入力例1
/// ```
/// 1
/// 2
/// ```
///
/// 読み込み例1
/// ```
/// [Int].stdin(rows: 2) // [1, 2]
/// ```
///
/// 入力例2
/// ```
/// 1 2
/// ```
///
/// 読み込み例2
/// ```
/// [Int].stdin(columns: 2) // [1, 2]
/// ```
///
/// 実際には空白や改行区切りの文字列として扱うため、例1と例2の読み込みコードを入れ替えても動作します。
///
///
/// 配列の配列にもメソッドが追加され、以下のような使用例が可能です
///
/// 入力例3
/// ```
/// 1 2
/// 3 4
/// ```
///
/// 読み込み例3
/// ```
/// [Int].stdin(rows: 2, columns: 2) // [[1, 2], [3, 4]]
/// ```
public protocol ArrayReadable: SingleReadable {}

extension Collection where Element: ArrayReadable {

  /// 標準入力から、空白または改行区切りの整数の連続を配列に読み込みます
  ///
  /// 現在は以下の要素型に対して適用されています
  ///
  /// 整数: Int, UInt, CInt, CUnsignedInt, CLongLong, CUnsignedLongLong
  ///
  /// 浮動小数: Double
  ///
  /// 入力例1
  /// ```
  /// 1 2
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// [Int].stdin(columns: 2) // [1, 2]
  /// ```
  @inlinable
  @inline(__always)
  public static func stdin(columns: Int) -> [Element] {
    try! read(columns: columns)
  }

  /// 標準入力から、空白または改行区切りの整数の連続を配列に読み込みます
  ///
  /// 現在は以下の要素型に対して適用されています
  ///
  /// 整数: Int, UInt, CInt, CUnsignedInt, CLongLong, CUnsignedLongLong
  ///
  /// 浮動小数: Double
  ///
  /// 入力例1
  /// ```
  /// 1
  /// 2
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// [Int].stdin(rows: 2) // [1, 2]
  /// ```
  @inlinable
  @inline(__always)
  public static func stdin(rows: Int) -> [Element] {
    try! read(rows: rows)
  }
}

extension Collection where Element: Collection, Element.Element: ArrayReadable {

  /// 標準入力から、空白または改行区切りの整数の連続を配列の配列に読み込みます
  ///
  /// 現在は以下の要素型に対して適用されています
  ///
  /// 整数: Int, UInt, CInt, CUnsignedInt, CLongLong, CUnsignedLongLong
  ///
  /// 浮動小数: Double
  ///
  /// 配列の配列にもメソッドが追加され、以下のような使用例が可能です
  ///
  /// 入力例3
  /// ```
  /// 1 2
  /// 3 4
  /// ```
  ///
  /// 読み込み例3
  /// ```
  /// [Int].stdin(rows: 2, columns: 2) // [[1, 2], [3, 4]]
  /// ```
  @inlinable
  @inline(__always)
  public static func stdin(rows: Int, columns: Int) -> [[Element.Element]] {
    try! read(rows: rows, columns: columns)
  }
}

// MARK: - Implementation

extension Collection where Element: ArrayReadable {
  
  @inlinable
  @inline(__always)
  public static func read(columns: Int) throws -> [Element] {
    try (0..<columns).map { _ in try .read() }
  }
  
  @inlinable
  @inline(__always)
  public static func read(rows: Int) throws -> [Element] {
    try (0..<rows).map { _ in try .read() }
  }
}

extension Collection where Element: Collection, Element.Element: ArrayReadable {
  
  @inlinable
  @inline(__always)
  public static func read(rows: Int, columns: Int) throws -> [[Element.Element]] {
    try (0..<rows).map { _ in try (0..<columns).map { _ in try .read() } }
  }
}

