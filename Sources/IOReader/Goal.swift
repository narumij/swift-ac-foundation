// プロトコル名が現れる必要はないが、概念的に以下のような振る舞いを手に入れる

public protocol ReadableUnit {}

public protocol ReadableAsciiLine: ReadableUnit {
  // String, [Character], [UInt8]
  static func stdin() -> Self
  static func stdin(columns: Int) -> Self
}

public protocol ReadableAsciiLines {
  associatedtype Unit: ReadableAsciiLine
  // [String], [[Character]], [[UInt8]]
  static func stdin(rows: Int) -> Self
  static func stdin(rows: Int, columns: Int) -> Self
}

public protocol ReadableAsciiWord: ReadableUnit {
  // String, [Character], [UInt8]
  static var stdin: Self { get }
  // cin互換風
}

public protocol ReadableAsciiWords1D {
  associatedtype Unit: ReadableAsciiWord
  // [String], [[Character]], [[UInt8]]
  static func stdin() -> Self
  static func stdin(columns: Int) -> Self
}

public protocol ReadableAsciiWords2D {
  associatedtype Unit: ReadableAsciiWord
  // 過剰なので、実装は不要。概念整理の為にある
  // [[String]], [[[Character]]], [[[UInt8]]]
  static func stdin(rows: Int, columns: Int) -> Self
}

public protocol ReadableNumber: ReadableUnit {
  // Int, Double
  static var stdin: Self { get }
  // cin互換風
}

public protocol ReadableNumbers1D {
  associatedtype Unit: ReadableNumber
  // [Int], [Double]
  static func stdin() -> Self
  static func stdin(rows: Int) -> Self
  static func stdin(columns: Int) -> Self
}

public protocol ReadableNumbers2D {
  associatedtype Unit: ReadableNumber
  // [[Int]], [[Double]]
  static func stdin(rows: Int, columns: Int) -> Self
}
