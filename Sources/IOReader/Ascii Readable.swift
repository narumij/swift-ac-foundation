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
  /// 文字種を問わずデリミタ分の文字を強制で消費します
  static var stdin: Self { get }

  static func read() throws -> Self
}

// MARK: - Implementation

extension AsciiReadable {
  
  @inlinable
  @inline(__always)
  public static var stdin: Self {
    try! .read()
  }
}

