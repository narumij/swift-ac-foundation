import Foundation

/// Array型に、文字列の配列に対する読み込み方法を加えるプロトコルです
///
/// 現在は以下の要素型に対して適用されています
///
/// 文字列: String, [Character], [UInt8]
///
/// 数値の場合とは異なり、columns引数は文字列の横幅の指定となります。
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
/// String.stdin(rows: 3, columns: 4) // ["####","#..#","####"]
/// ```
///
/// 入力側の文字列がcolumn引数より長い場合、残りの文字は標準入力に残したままとなり、次の読み込みの際に使われます
///
public protocol AsciiArrayReadable: SingleReadable {}
