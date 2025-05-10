@preconcurrency import Foundation

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

extension SingleReadable {
  @inlinable
  @inline(__always)
  public static var stdin: Self {
    try! read()
  }
}

public protocol LineReadable: SingleReadable {
  static func readWithSeparator() throws -> (value: Self, separator: UInt8)
}

extension LineReadable {
  public static func read() throws -> Self {
    try readWithSeparator().value
  }
}

// MARK: -

extension Int: ArrayReadable & LineReadable {}
extension UInt: ArrayReadable & LineReadable {}
extension Double: ArrayReadable & LineReadable {}
extension CInt: ArrayReadable & LineReadable {}
extension CUnsignedInt: ArrayReadable & LineReadable {}
extension CLongLong: ArrayReadable & LineReadable {}
extension CUnsignedLongLong: ArrayReadable & LineReadable {}

extension String: StringReadable & LineReadable {}
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

extension Collection where Element: LineReadable {
  
  @inlinable @inline(__always)
  public static func readLine() -> [Element]? {
    do {
      var result = [Element]()
      while true {
        let (element, separator) = try Element.readWithSeparator()
        result.append(element)
        if separator == .LF || separator == .CR || separator == .NULL {
          break
        }
      }
      return result
    } catch {
      return nil
    }
  }
}

extension Collection where Element == [UInt8] {

  @inlinable @inline(__always)
  public static func readLine() -> [Element]? {
    do {
      var result = [Element]()
      while true {
        let (element, separator) = try Element.readWithSeparator()
        result.append(element)
        if separator == .LF || separator == .CR || separator == .NULL {
          break
        }
      }
      return result
    } catch {
      return nil
    }
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

// MARK: -

extension FixedWidthInteger {

  @inlinable @inline(__always)
  public static func readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try asException(try ATOL.read().map { (.init($0.value), $0.separator) })
  }
}

extension BinaryFloatingPoint {

  @inlinable @inline(__always)
  public static func readWithSeparator() throws -> (value: Self, separator: UInt8) {
    try asException(try ATOF.read().map { (.init($0.value), $0.separator) })
  }
}

extension String {

  @inlinable @inline(__always)
  public static func readWithSeparator() throws -> (value: String, separator: UInt8) {
    try asException(try ATOS.read())
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
  public static func stdin(columns: Int) -> String { try! read(columns: columns) }
}

extension String {

  @inlinable @inline(__always)
  public static func read(columns: Int) throws -> String {
    try asException(try ATOS.read(columns: columns, hasSeparator: true)).value
  }

  @inlinable @inline(__always)
  public static func read(columns: Int, hasSeparator: Bool) throws -> (
    value: String, separator: UInt8
  ) {
    try asException(try ATOS.read(columns: columns, hasSeparator: true))
  }
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
  public static func read() throws -> UInt8 {
    try read(hasSeparator: true)
  }

  @inlinable @inline(__always)
  public static func read(hasSeparator sep: Bool) throws -> UInt8 {
    try asException(try ATOB.read(columns: 1, hasSeparator: sep).value.first)
  }

  @inlinable @inline(__always)
  public static var stdin: Self { try! read() }
}

extension Array where Element == UInt8 {

  @inlinable @inline(__always)
  public static func read() throws -> [UInt8] {
    try readWithSeparator().value
  }

  @inlinable @inline(__always)
  public static func readWithSeparator() throws -> (value: [UInt8], separator: UInt8) {
    try asException(try ATOB.read())
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
  /// 区切りがない一行を読む場合、Swfit.readline()が圧倒的に高速ですので、そちらをお勧めします。
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
  public static func stdin(columns: Int) -> [UInt8] { try! read(columns: columns) }
}

extension Array where Element == UInt8 {

  @inlinable @inline(__always)
  public static func read(columns: Int) throws -> [UInt8] {
    try ATOB.read(columns: columns, hasSeparator: true).value
  }

  @inlinable @inline(__always)
  public static func read(columns: Int, hasSeparator: Bool) throws -> (
    value: [UInt8], separator: UInt8
  ) {
    try ATOB.read(columns: columns, hasSeparator: true)
  }
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
  public static func read() throws -> Character {
    try Character(String.read(columns: 1))
  }

  @inlinable
  public static var stdin: Self { try! read() }
}

extension Array where Element == Character {

  @inlinable
  public static func read() throws -> [Character] {
    try readWithSeparator().value
  }

  @inlinable
  public static func readWithSeparator() throws -> (value: [Character], separator: UInt8) {
    let (a, b) = try String.readWithSeparator()
    return (a.map { $0 }, b)
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
  /// 区切りがない一行を読む場合、Swfit.readline()が圧倒的に高速ですので、そちらをお勧めします。
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
enum Error: Swift.Error {
  case unexpectedNil
  case unexpectedEOF
}

@usableFromInline protocol IOReader {}

@usableFromInline protocol FixedBufferIOReader: IOReader {
  var buffer: [UInt8] { get set }
}

extension FixedWidthInteger {
  @inlinable @inline(__always) static var NULL: Self { 0x00 }
  @inlinable @inline(__always) static var HT: Self { 0x09 }
  @inlinable @inline(__always) static var LF: Self { 0x0A }
  @inlinable @inline(__always) static var CR: Self { 0x0D }
  @inlinable @inline(__always) static var SP: Self { 0x20 }
}

extension FixedWidthInteger {

  @inlinable @inline(__always)
  static func __readHead() throws -> Self {
    var head: Self
    repeat {
      let c = getchar_unlocked()
      if c == -1 {
        throw Error.unexpectedEOF
      }
      head = numericCast(c)
    } while head == .SP || head == .LF || head == .CR || head == .HT
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
          throw Error.unexpectedEOF
        }
        return numericCast(c)
      }
  }
}

extension FixedBufferIOReader {

  @inlinable @inline(__always)
  mutating func _next<T>(_ f: (UnsafePointer<UInt8>) -> T) throws -> (T, UInt8)? {
    var current = 0
    return try buffer.withUnsafeMutableBufferPointer { buffer in
      buffer.baseAddress![current] = try .__readHead()
      while buffer.baseAddress![current] != .NULL,
        buffer.baseAddress![current] != .HT,
        buffer.baseAddress![current] != .LF,
        buffer.baseAddress![current] != .CR,
        buffer.baseAddress![current] != .SP
      {
        current += 1
        let c = getchar_unlocked()
        buffer[current] = c == -1 ? .NULL : numericCast(c)
      }
      return current == 0 ? nil : (f(buffer.baseAddress!), buffer.baseAddress![current])
    }
  }
}

@usableFromInline protocol VariableBufferIOReader: IOReader {
  associatedtype BufferElement: FixedWidthInteger
  var buffer: [BufferElement] { get set }
}

extension VariableBufferIOReader {
  @inlinable @inline(__always)
  mutating func _next<T>(_ f: (UnsafeBufferPointer<BufferElement>, Int) -> T?) throws -> (
    T, BufferElement
  )? {
    var current = 0
    buffer[current] = try .__readHead()
    while buffer[current] != .NULL,
      buffer[current] != .HT,
      buffer[current] != .LF,
      buffer[current] != .CR,
      buffer[current] != .SP
    {
      current += 1
      if current == buffer.count {
        buffer.append(contentsOf: repeatElement(0, count: buffer.count))
      }
      let c = getchar_unlocked()
      buffer[current] = c == -1 ? .NULL : BufferElement(truncatingIfNeeded: c)
    }
    return buffer.withUnsafeBufferPointer { f($0, current) }.map { ($0, buffer[current]) }
  }
}

@usableFromInline
protocol IOReaderInstance {
  associatedtype Element
  mutating func next() throws -> Self.Element
  static var instance: Self { get set }
}

extension IOReaderInstance {
  @inlinable @inline(__always) static func read() throws -> Element! { try instance.next() }
}

@usableFromInline
protocol IOReaderInstance2 {
  associatedtype Element
  mutating func next() throws -> Self.Element?
  static var instance: Self { get set }
}

extension IOReaderInstance2 {
  @inlinable @inline(__always) static func read() throws -> Element! { try instance.next() }
}

@usableFromInline struct ATOL: FixedBufferIOReader, IOReaderInstance2 {
  public var buffer = [UInt8](repeating: 0, count: 32)
  @inlinable @inline(__always)
  public mutating func next() throws -> (value: Int, separator: UInt8)? { try _next { atol($0) } }
  nonisolated(unsafe) public static var instance = Self()
}

@usableFromInline struct ATOF: FixedBufferIOReader, IOReaderInstance2 {
  public var buffer = [UInt8](repeating: 0, count: 64)
  @inlinable @inline(__always)
  public mutating func next() throws -> (value: Double, separator: UInt8)? {
    try _next { atof($0) }
  }
  nonisolated(unsafe) public static var instance = Self()
}

@inlinable @inline(__always)
func asSeparator(_ c: Int32) -> UInt8 {
  c == -1 ? .NULL : UInt8(c)
}

@inlinable @inline(__always)
func asException<T>(_ a: T?) throws -> T {
  guard let a else {
    throw Error.unexpectedNil
  }
  return a
}

@usableFromInline struct ATOB: VariableBufferIOReader, IOReaderInstance {
  public var buffer: [UInt8] = .init(repeating: 0, count: 32)
  @inlinable @inline(__always)
  public mutating func next() throws -> (value: [UInt8], separator: UInt8)? {
    try _next { Array($0[0..<$1]) }
  }
  nonisolated(unsafe) public static var instance = Self()
  @inlinable @inline(__always) static func read(columns: Int, hasSeparator: Bool) throws -> (
    value: [UInt8], separator: UInt8
  ) {
    return (
      try .__readBytes(count: columns), hasSeparator ? asSeparator(getchar_unlocked()) : .NULL
    )
  }
}

@usableFromInline struct ATOS: VariableBufferIOReader, IOReaderInstance {
  public var buffer = [UInt8](repeating: 0, count: 32)
  @inlinable @inline(__always)
  public mutating func next() throws -> (value: String, separator: UInt8)? {
    try _next { b, c in String(bytes: b[0..<c], encoding: .ascii) }
  }
  nonisolated(unsafe) public static var instance = Self()
  @inlinable @inline(__always) static func read(columns: Int, hasSeparator: Bool) throws -> (
    value: String, separator: UInt8
  )? {
    return String(bytes: try Array.__readBytes(count: columns), encoding: .ascii)
      .map { ($0, hasSeparator ? asSeparator(getchar_unlocked()) : .NULL) }
  }
}
