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

  func testWords2DRows() throws {
    try SolverRunner {
      XCTAssertEqual([[String]].stdin(rows: 2), [["abc", "def"], ["ghi"]])
    }.inputOnly("abc def\nghi")
  }

  func testWords2D() throws {
    try SolverRunner {
      XCTAssertEqual([[String]].stdin(rows: 2, columns: 2), [["a", "b"], ["c", "d"]])
    }.inputOnly("a b\nc d")
  }

  func testWordsColumns() throws {
    try SolverRunner {
      XCTAssertEqual([String].stdin(columns: 3), ["a", "bc", "def"])
    }.inputOnly("a bc def")
  }
}

final class CharacterReaderTests: XCTestCase {

  func testWords2DRows() throws {
    try SolverRunner {
      XCTAssertEqual([[[Character]]].stdin(rows: 2), [[Array("abc"), Array("def")], [Array("ghi")]])
    }.inputOnly("abc def\nghi")
  }

  func testWords2D() throws {
    try SolverRunner {
      XCTAssertEqual(
        [[[Character]]].stdin(rows: 2, columns: 2), [[Array("a"), Array("b")], [Array("c"), Array("d")]])
    }.inputOnly("a b\nc d")
  }

  func testWord() throws {
    try SolverRunner {
      XCTAssertEqual([Character].stdin, Array("abc"))
      XCTAssertEqual([Character].stdin, Array("de"))
    }.inputOnly("abc de")
  }

  func testWordsLine() throws {
    try SolverRunner {
      XCTAssertEqual([[Character]].stdin(), [Array("abc"), Array("def")])
      XCTAssertEqual([[Character]].stdin(), [Array("ghi")])
    }.inputOnly("abc def\nghi")
  }

  func testWordsColumns() throws {
    try SolverRunner {
      XCTAssertEqual([[Character]].stdin(columns: 3), [Array("a"), Array("bc"), Array("def")])
    }.inputOnly("a bc def")
  }

  func testCharacter() throws {
    try SolverRunner {
      XCTAssertEqual(Character.stdin, "a")
      XCTAssertEqual(Character.stdin, "b")
    }.inputOnly("a b")
  }

  func testReadLine() throws {
    try SolverRunner {
      XCTAssertEqual([Character].readLine(), Array("abc def"))
      XCTAssertEqual([Character].readLine(), Array("ghi"))
    }.inputOnly("abc def\nghi")
  }

  func testLineColumns() throws {
    try SolverRunner {
      XCTAssertEqual([Character].stdin(columns: 3), Array("abc"))
      XCTAssertEqual([Character].stdin(columns: 2), Array("de"))
    }.inputOnly("abc\nde")
  }

  func testLinesRows() throws {
    try SolverRunner {
      XCTAssertEqual([[Character]].stdin(rows: 2), [Array("a b"), Array("c d")])
    }.inputOnly("a b\nc d")
  }

  func testLinesRowsColumns() throws {
    try SolverRunner {
      XCTAssertEqual(
        [[Character]].stdin(rows: 3, columns: 4), [Array("####"), Array("#..#"), Array("####")])
    }.inputOnly("####\n#..#\n####")
  }
}

final class UInt8ReaderTests: XCTestCase {

  func testWords2DRows() throws {
    try SolverRunner {
      XCTAssertEqual(
        [[[UInt8]]].stdin(rows: 2), [[Array("abc".utf8), Array("def".utf8)], [Array("ghi".utf8)]])
    }.inputOnly("abc def\nghi")
  }

  func testWords2D() throws {
    try SolverRunner {
      XCTAssertEqual(
        [[[UInt8]]].stdin(rows: 2, columns: 2),
        [[Array("a".utf8), Array("b".utf8)], [Array("c".utf8), Array("d".utf8)]])
    }.inputOnly("a b\nc d")
  }

  func testWord() throws {
    try SolverRunner {
      XCTAssertEqual([UInt8].stdin, Array("abc".utf8))
      XCTAssertEqual([UInt8].stdin, Array("de".utf8))
    }.inputOnly("abc de")
  }

  func testWordsLine() throws {
    try SolverRunner {
      XCTAssertEqual([[UInt8]].stdin(), [Array("abc".utf8), Array("def".utf8)])
      XCTAssertEqual([[UInt8]].stdin(), [Array("ghi".utf8)])
    }.inputOnly("abc def\nghi")
  }

  func testWordsColumns() throws {
    try SolverRunner {
      XCTAssertEqual(
        [[UInt8]].stdin(columns: 3), [Array("a".utf8), Array("bc".utf8), Array("def".utf8)])
    }.inputOnly("a bc def")
  }

  func testUInt8() throws {
    try SolverRunner {
      XCTAssertEqual(UInt8.stdin, UInt8(ascii: "a"))
      XCTAssertEqual(UInt8.stdin, UInt8(ascii: "b"))
    }.inputOnly("a b")
  }

  func testReadLine() throws {
    try SolverRunner {
      XCTAssertEqual([UInt8].readLine(), Array("abc def".utf8))
      XCTAssertEqual([UInt8].readLine(), Array("ghi".utf8))
    }.inputOnly("abc def\nghi")
  }

  func testLineColumns() throws {
    try SolverRunner {
      XCTAssertEqual([UInt8].stdin(columns: 3), Array("abc".utf8))
      XCTAssertEqual([UInt8].stdin(columns: 2), Array("de".utf8))
    }.inputOnly("abc\nde")
  }

  func testLinesRows() throws {
    try SolverRunner {
      XCTAssertEqual([[UInt8]].stdin(rows: 2), [Array("a b".utf8), Array("c d".utf8)])
    }.inputOnly("a b\nc d")
  }

  func testLinesRowsColumns() throws {
    try SolverRunner {
      XCTAssertEqual(
        [[UInt8]].stdin(rows: 3, columns: 4),
        [Array("####".utf8), Array("#..#".utf8), Array("####".utf8)])
    }.inputOnly("####\n#..#\n####")
  }
}
