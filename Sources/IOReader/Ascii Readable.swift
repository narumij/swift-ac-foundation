import Foundation

public protocol AsciiReadable: SingleReadable {
  
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
  static var stdin: Self { get }

  static func read() throws -> Self
}

// MARK: - Implementation

extension AsciiReadable {
  
  @inlinable
  public static var stdin: Self {
    try! .read()
  }
}

