import IOReaderV2
import TestingUtil
import XCTest

final class IntReaderTests: XCTestCase {

  func testNumber() throws {
    try SolverRunner {
      XCTAssertEqual(Int.stdin, 1)
      XCTAssertEqual(Int.stdin, -2)
    }.inputOnly("1 -2")
  }

  func testNumbersLine() throws {
    try SolverRunner {
      XCTAssertEqual([Int].stdin(), [1, 2, 3])
      XCTAssertEqual([Int].stdin(), [4])
    }.inputOnly("1 2 3\n4")
  }

  func testNumbersLineThenReadLine() throws {
    try SolverRunner {
      XCTAssertEqual([Int].stdin(), [1, 2])
      XCTAssertEqual(String.readLine(), "a b")
    }.inputOnly("1 2\na b")
  }

  func testNumbersRows() throws {
    try SolverRunner {
      XCTAssertEqual([Int].stdin(rows: 3), [1, 2, 3])
    }.inputOnly("1\n2\n3")
  }

  func testNumbersColumns() throws {
    try SolverRunner {
      XCTAssertEqual([Int].stdin(columns: 3), [1, 2, 3])
    }.inputOnly("1 2 3")
  }

  func testNumbers2DRows() throws {
    try SolverRunner {
      XCTAssertEqual([[Int]].stdin(rows: 2), [[1, 2, 3], [4]])
    }.inputOnly("1 2 3\n4")
  }

  func testNumbers2D() throws {
    try SolverRunner {
      XCTAssertEqual([[Int]].stdin(rows: 2, columns: 3), [[1, 2, 3], [4, 5, 6]])
    }.inputOnly("1 2 3\n4 5 6")
  }
}

final class StringReaderTests: XCTestCase {

  func testReadLine() throws {
    try SolverRunner {
      XCTAssertEqual(String.readLine(), "abc def")
      XCTAssertEqual(String.readLine(), "ghi")
    }.inputOnly("abc def\nghi")
  }

  func testLineColumns() throws {
    try SolverRunner {
      XCTAssertEqual(String.stdin(columns: 3), "abc")
      XCTAssertEqual(String.stdin(columns: 2), "de")
    }.inputOnly("abc\nde")
  }

  func testLinesRows() throws {
    try SolverRunner {
      XCTAssertEqual([String].stdin(rows: 2), ["a b", "c d"])
    }.inputOnly("a b\nc d")
  }

  func testLinesRowsColumns() throws {
    try SolverRunner {
      XCTAssertEqual([String].stdin(rows: 3, columns: 4), ["####", "#..#", "####"])
    }.inputOnly("####\n#..#\n####")
  }

  func testWord() throws {
    try SolverRunner {
      XCTAssertEqual(String.stdin, "abc")
      XCTAssertEqual(String.stdin, "def")
    }.inputOnly("abc def")
  }

  func testWordsLine() throws {
    try SolverRunner {
      XCTAssertEqual([String].stdin(), ["abc", "def"])
      XCTAssertEqual([String].stdin(), ["ghi"])
    }.inputOnly("abc def\nghi")
  }

  func testWordsColumns() throws {
    try SolverRunner {
      XCTAssertEqual([String].stdin(columns: 3), ["a", "bc", "def"])
    }.inputOnly("a bc def")
  }
}
