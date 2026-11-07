import Foundation

/// 浮動小数の読取り失敗。inputは消費した候補、nextByteは消費せず残した文字。
public struct FloatingPointInputError: Error, Equatable, CustomStringConvertible, LocalizedError {
  public let reason: IOReaderError
  public let input: String
  public let nextByte: UInt8?

  public init(reason: IOReaderError, input: String, nextByte: UInt8?) {
    self.reason = reason
    self.input = input
    self.nextByte = nextByte
  }

  public var description: String {
    let detail = reason == .floatingPointOutOfRange
      ? "数値が表現範囲外です" : "数値の構文が不正または未完成です"
    let next = nextByte.map { String(UnicodeScalar($0)).debugDescription } ?? "EOF"
    return "Doubleとして読み取れません: \(input.debugDescription)（\(detail)、次の文字: \(next)）"
  }

  public var errorDescription: String? { description }
}
