import Foundation

/// 単一の数値や文字列に対する読み込み方法を与えるプロトコルです
///
/// 現在は以下の型に対して適用されています
///
/// 整数: Int, UInt, CInt, CUnsignedInt, CLongLong, CUnsignedLongLong
///
/// 浮動小数: Double
///
/// 文字: Character, UInt8
///
/// 文字列: String, [Character], [UInt8]
///
/// UInt8型は文字や文字列の一種となっており、整数の入力を受け付けることはできません
///
/// また文字列に対して使用した場合、空白または改行までを読み込みます
///
public protocol SingleReadable {

  /// 標準入力の値を読み、値として返します
  ///
  /// 入力例1
  /// ```
  /// 1
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(Int.stdin) // 1
  /// ```
  ///
  /// 入力例2
  /// ```
  /// 1 2
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(Int.stdin, Int.stdin) // 1 2
  /// ```
  ///
  static var stdin: Self { get }

  /// 標準入力の値を読み、値として返します
  ///
  /// 入力例1
  /// ```
  /// 1
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(try! Int.read()) // 1
  /// ```
  ///
  /// 入力例2
  /// ```
  /// 1 2
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(try! Int.read(), try! Int.read()) // 1 2
  /// ```
  ///
  static func read() throws -> Self
}

// MARK: - Implementation

extension SingleReadable {

  @inlinable
  @inline(__always)
  public static var stdin: Self {
    try! read()
  }
}
