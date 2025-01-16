import Foundation
import Synchronization

// MARK: - Reader

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

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得し、値に変換した結果を返します
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
  /// EOFを超えて読もうとした場合、クラッシュします
  ///
  static var stdin: Self { get }

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得し、値に変換した結果を返します
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
  /// EOFを超えて読もうとした場合、例外を投げます
  ///
  static func read() throws -> Self
}

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
public protocol StringReadable: SingleReadable {}

extension Int: ArrayReadable {}
extension UInt: ArrayReadable {}
extension Double: ArrayReadable {}
extension CInt: ArrayReadable {}
extension CUnsignedInt: ArrayReadable {}
extension CLongLong: ArrayReadable {}
extension CUnsignedLongLong: ArrayReadable {}

extension String: StringReadable {}
extension Character: StringReadable {}
extension UInt8: StringReadable {}

extension Collection where Element: ArrayReadable {

  @inlinable @inline(__always)
  public static func read(columns: Int) throws -> [Element] {
    try (0..<columns).map { _ in try .read() }
  }

  @inlinable @inline(__always)
  public static func read(rows: Int) throws -> [Element] {
    try (0..<rows).map { _ in try .read() }
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
  /// 1 2
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// [Int].stdin(columns: 2) // [1, 2]
  /// ```
  @inlinable @inline(__always)
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
  @inlinable @inline(__always)
  public static func stdin(rows: Int) -> [Element] {
    try! read(rows: rows)
  }
}

extension Collection where Element: Collection, Element.Element: ArrayReadable {

  @inlinable @inline(__always)
  public static func read(rows: Int, columns: Int) throws -> [[Element.Element]] {
    try (0..<rows).map { _ in try (0..<columns).map { _ in try .read() } }
  }

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
  @inlinable @inline(__always)
  public static func stdin(rows: Int, columns: Int) -> [[Element.Element]] {
    try! read(rows: rows, columns: columns)
  }
}

extension FixedWidthInteger {

  @inlinable @inline(__always)
  public static func read() throws -> Self { .init(try ATOL.read()!) }

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得し、値に変換した結果を返します
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
  /// EOFを超えて読もうとした場合、クラッシュします
  ///
  @inlinable @inline(__always)
  public static var stdin: Self { try! read() }
}

extension BinaryFloatingPoint {

  @inlinable @inline(__always)
  public static func read() throws -> Self { .init(try ATOF.read()!) }

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得し、値に変換した結果を返します
  ///
  /// 入力例1
  /// ```
  /// 1.25
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(Double.stdin) // 1.25
  /// ```
  ///
  /// 入力例2
  /// ```
  /// 1.25 2.5
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(Double.stdin, Double.stdin) // 1.25 2.t
  /// ```
  ///
  /// EOFを超えて読もうとした場合、クラッシュします
  ///
  @inlinable @inline(__always)
  public static var stdin: Self { try! read() }
}

extension String {

  @inlinable @inline(__always)
  public static func read() throws -> String { ATOS.read() }

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(String.stdin) // abcde
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abc def
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(String.stdin, String.stdin) // abc def
  /// ```
  ///
  /// 区切りがなく、一行を読む場合、Swfit.readline()が圧倒的に高速ですので、そちらをお勧めします。
  @inlinable @inline(__always)
  public static var stdin: Self { try! read() }

  /// 標準入力から空白や改行以外の文字列を文字数を指定して取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(String.stdin(columns: 5)) // abcde
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abcdef
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(String.stdin(columns: 3), String.stdin(columns: 3)) // abc def
  /// ```
  @inlinable
  public static func stdin(columns: Int) -> String { ATOS.read(columns: columns) }
}

extension Array where Element == String {

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
  /// String.stdin(rows: 3) // ["####","#..#","####"]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [String] {
    (0..<rows).map { _ in try! .read() }
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
  /// String.stdin(rows: 3, columns: 4) // ["####","#..#","####"]
  /// ```
  ///
  /// 入力側の文字列がcolumn引数より長い場合、残りの文字は標準入力に残したままとなり、次の読み込みの際に使われます
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [String] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}

extension UInt8 {

  @inlinable @inline(__always)
  public static func read() throws -> UInt8 { ATOB.read(columns: 1).first! }

  @inlinable @inline(__always)
  public static var stdin: Self { try! read() }
}

extension Array where Element == UInt8 {

  @inlinable @inline(__always)
  public static func read() throws -> [UInt8] { ATOB.read() }

  /// 標準入力から空白や改行以外の文字列を空白や改行やEOFまで取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(String.stdin) // [0x61, 0x62, 0x63, 0x64, 0x65]
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abc def
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(String.stdin, String.stdin) // [[0x61, 0x62, 0x63], [0x64, 0x65, 0x66]]
  /// ```
  ///
  /// 区切りがなく、一行を読む場合、Swfit.readline()が圧倒的に高速ですので、そちらをお勧めします。
  @inlinable @inline(__always)
  public static var stdin: Self { try! read() }

  /// 標準入力から空白や改行以外の文字列を文字数を指定して取得します
  ///
  /// 入力例1
  /// ```
  /// abcde
  /// ```
  ///
  /// 読み込み例1
  /// ```
  /// print(String.stdin(columns: 5)) // [0x61, 0x62, 0x63, 0x64, 0x65]
  /// ```
  ///
  /// 入力例2
  /// ```
  /// abcdef
  /// ```
  ///
  /// 読み込み例2
  /// ```
  /// print(String.stdin(columns: 3), String.stdin(columns: 3)) // [[0x61, 0x62, 0x63], [0x64, 0x65, 0x66]]
  /// ```
  @inlinable
  public static func stdin(columns: Int) -> [UInt8] { ATOB.read(columns: columns) }
}

extension Array where Element == [UInt8] {

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
  /// String.stdin(rows: 3) // [[0x23,0x23,0x23,0x23],[0x23,0x2e,0x2e,0x23],[0x23,0x23,0x23,0x23]]
  /// ```
  @inlinable
  public static func stdin(rows: Int) -> [[UInt8]] {
    (0..<rows).map { _ in try! .read() }
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
  /// String.stdin(rows: 3, columns: 4) // ["####","#..#","####"]
  /// ```
  ///
  /// 入力側の文字列がcolumn引数より長い場合、残りの文字は標準入力に残したままとなり、次の読み込みの際に使われます
  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [[UInt8]] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}

extension Character {

  @inlinable
  public static func read() throws -> Character { Character(String.stdin(columns: 1)) }

  @inlinable
  public static var stdin: Self { try! read() }
}

extension Array where Element == Character {

  @inlinable
  public static func read() throws -> [Character] {
    try String.read().map { $0 }
  }

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
  /// 区切りがなく、一行を読む場合、Swfit.readline()が圧倒的に高速ですので、そちらをお勧めします。
  @inlinable
  public static var stdin: Self { try! read() }

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
    String.stdin(columns: columns).map { $0 }
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
    (0..<rows).map { _ in try! .read() }
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
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}

// MARK: - IOReader

@usableFromInline
enum IOReaderError: Swift.Error {
  case unexpectedEOF
}

@usableFromInline protocol IOReader: AnyObject {}

@usableFromInline protocol FixedBufferIOReader: IOReader {
  var buffer: [UInt8] { get set }
}

extension FixedWidthInteger {
  @inlinable @inline(__always) static var SP: Self { 0x20 }
  @inlinable @inline(__always) static var LF: Self { 0x0A }
}

extension FixedWidthInteger {

  @inlinable @inline(__always)
  static func __readHead() throws -> Self {
    var head: Self
    repeat {
      let c = getchar_unlocked()
      if c == -1 {
        throw IOReaderError.unexpectedEOF
      }
      head = numericCast(c)
    } while head == .SP || head == .LF
    return head
  }
}

extension Array where Element: FixedWidthInteger {

  @inlinable @inline(__always)
  static func __readBytes(count: Int) throws -> Self {
    let h: Element = try .__readHead()
    return try [h]
      + (1..<count).map { _ in
        let c = getchar_unlocked()
        if c == -1 {
          throw IOReaderError.unexpectedEOF
        }
        return numericCast(c)
      }
  }
}

extension FixedBufferIOReader {

  @inlinable @inline(__always)
  func _next<T>(_ f: (UnsafePointer<UInt8>) -> T) throws -> T? {
    var current = 0
    return try buffer.withUnsafeMutableBufferPointer { buffer in
      buffer.baseAddress![current] = try .__readHead()
      while buffer.baseAddress![current] != .SP,
        buffer.baseAddress![current] != .LF,
        buffer.baseAddress![current] != EOF
      {
        current += 1
        let c = getchar_unlocked()
        if c == -1 {
          throw IOReaderError.unexpectedEOF
        }
        buffer[current] = numericCast(c)
      }
      return current == 0 ? nil : f(buffer.baseAddress!)
    }
  }
}

@usableFromInline protocol VariableBufferIOReader: IOReader {
  associatedtype BufferElement: FixedWidthInteger
  var buffer: [BufferElement] { get set }
}

extension VariableBufferIOReader {
  @inlinable
  @inline(__always)
  func _next<T>(_ f: (UnsafeBufferPointer<BufferElement>, Int) -> T?) throws -> T? {
    var current = 0
    buffer[current] = try .__readHead()
    while buffer[current] != .SP, buffer[current] != .LF, buffer[current] != 0 {
      current += 1
      if current == buffer.count {
        buffer.append(contentsOf: repeatElement(0, count: buffer.count))
      }
      buffer[current] = BufferElement(truncatingIfNeeded: getchar_unlocked())
    }
    return buffer.withUnsafeBufferPointer { f($0, current) }
  }
}

@usableFromInline
protocol IOReaderInstance: IteratorProtocol {
  static var instance: Self { get set }
}

extension IOReaderInstance {
  @inlinable
  @inline(__always)
  static func read() -> Element! { instance.next() }
}

@usableFromInline
protocol IOReaderInstance2 {
  associatedtype Element
  mutating func next() throws -> Self.Element?
  static var instance: Self { get set }
}

extension IOReaderInstance2 {
  @inlinable
  @inline(__always)
  static func read() throws -> Element! { try instance.next() }
}

@usableFromInline final class ATOL: FixedBufferIOReader, IOReaderInstance2 {
  
  init() { }
  
  public var buffer = [UInt8](repeating: 0, count: 32)
  
  @nonobjc
  @inlinable
  @inline(__always)
  public func next() throws -> Int? {
    try _next { atol($0) }
  }
  
  nonisolated(unsafe)
  public static var instance: ATOL = .init()
}

@usableFromInline final class ATOF: FixedBufferIOReader, IOReaderInstance2 {
  
  init() { }
  
  public var buffer = [UInt8](repeating: 0, count: 64)
  
  @nonobjc
  @inlinable
  @inline(__always)
  public func next() throws -> Double? {
    try _next { atof($0) }
  }
  
  nonisolated(unsafe)
  public static var instance: ATOF = .init()
}

@usableFromInline final class ATOB: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
  
  init() { }
  
  public var buffer: [UInt8] = .init(repeating: 0, count: 32)
  
  @nonobjc
  @inlinable
  @inline(__always)
  public func next() -> [UInt8]? { try! _next { Array($0[0..<$1]) } }
  
  nonisolated(unsafe)
  public static var instance: ATOB = .init()
  
  @nonobjc
  @inlinable
  @inline(__always)
  static func read(columns: Int) -> [UInt8] {
    defer { getchar_unlocked() }
    return try! .__readBytes(count: columns)
  }
}

@usableFromInline final class ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
  
  init() { }
  
  public var buffer = [UInt8](repeating: 0, count: 32)
  
  @nonobjc
  @inlinable
  @inline(__always)
  public func next() -> String? {
    try! _next { b, c in String(bytes: b[0..<c], encoding: .ascii) }
  }
  
  nonisolated(unsafe)
  public static var instance: ATOS = .init()
  
  @nonobjc
  @inlinable
  @inline(__always)
  static func read(columns: Int) -> String! {
    defer { getchar_unlocked() }
    return String(bytes: try! Array.__readBytes(count: columns), encoding: .ascii)
  }
}
