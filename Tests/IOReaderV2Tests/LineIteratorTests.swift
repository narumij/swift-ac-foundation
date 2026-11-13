import IOReaderV2
import TestingUtil
import XCTest

// 1行の読み取りは改行をまたがない（行末の空白があっても次の行を読まない）
final class LineIteratorTests: IOReaderV2TestCase {

  func testLineStopsAtNewlineAfterTrailingSpace() throws {
    try SolverRunner(solver: {
      XCTAssertEqual([Int].stdin(), [1, 2])
      XCTAssertEqual(Int.stdin, 3)
    })
    .inputOnly("1 2 \n3\n")
  }

  func testWordLineStopsAtNewlineAfterTrailingSpace() throws {
    try SolverRunner(solver: {
      XCTAssertEqual([String].stdin(), ["a", "b"])
      XCTAssertEqual(String.stdin, "c")
    })
    .inputOnly("a b  \nc\n")
  }

  func testLineWithoutTrailingSpace() throws {
    try SolverRunner(solver: {
      XCTAssertEqual([Int].stdin(), [1, 2, 3])
      XCTAssertEqual([Int].stdin(), [4])
    })
    .inputOnly("1 2 3\n4")
  }
}
