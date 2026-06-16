import IOUtil
import TestingUtil
import XCTest

final class GetLineTests: XCTestCase {

  func testWithUnsafeReadLineBytesProvidesLineBytes() throws {
    var captured: String = ""

    try SolverRunner {
      captured = try withUnsafeReadLineBytes { line in
        String(decoding: line, as: UTF8.self)
      }
    }.inputOnly("abc def")

    XCTAssertEqual(captured, "abc def\n")
  }

  func testWithUnsafeReadLineBytesPropagatesBodyError() throws {
    let runner = SolverRunner {
      XCTAssertThrowsError(
        try withUnsafeReadLineBytes { _ in
          throw SampleError.expected
        }
      ) { error in
        XCTAssertEqual(error as? SampleError, .expected)
      }
    }

    try runner.inputOnly("1 2 3")
  }

  func testReadIntLineHandlesLeadingRepeatedAndTrailingSpaces() throws {
    // 生成したベンチマーク入力などでは、行頭・token 間・行末に余分な空白が
    // 入ることがある。この空白は区切りとしてだけ扱いたいので、
    // `"   -10   0 20   "` は `[-10, 0, 20]` として読み取り、SolverRunner が
    // 付ける改行で停止してほしい。修正前は末尾空白の後でも外側の loop が
    // `_parseSigned` をもう一度呼び、parser が改行を数値の先頭として扱いかけて
    // line buffer の範囲外まで進んでいた。現在は parse 前に空白を読み飛ばし、
    // 改行または終端に到達していたらそこで停止する。
    try SolverRunner {
      let values: [Int] = readIntLine()
      XCTAssertEqual(values, [-10, 0, 20])
    }.inputOnly("   -10   0 20   ")
  }

  func testReadUIntLineHandlesLeadingRepeatedAndTrailingSpaces() throws {
    // 符号なし整数でも同じ末尾空白の回帰を確認する。修正前は最後の区切りの後で
    // さらに parse しようとしていたため、UInt では改行から不正な digit 値を
    // 作りかけた後、parser が範囲外へ進む可能性があった。期待する動作は、
    // token の前後の区切りを無視し、行に存在する 3 つの数値だけを返すこと。
    try SolverRunner {
      let values: [UInt] = readUIntLine()
      XCTAssertEqual(values, [10, 0, 20])
    }.inputOnly("   10   0 20   ")
  }

  private enum SampleError: Error, Equatable {
    case expected
  }
}
