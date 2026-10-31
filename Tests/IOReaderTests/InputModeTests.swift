import IOReader
import TestingUtil
import XCTest

final class InputModeTests: XCTestCase {
  func testTextRepresentationsAndWordRows() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(String.stdin(read: .line), "a b")
      XCTAssertEqual([Character].stdin(read: .line), Array("c d"))
      XCTAssertEqual([UInt8].stdin(read: .line), Array("e f".utf8))
      XCTAssertEqual(try [String].read(read: .words), ["aa", "bb"])
      XCTAssertEqual([[Character]].stdin(read: .words), [Array("cc"), Array("dd")])
      XCTAssertEqual(try [[UInt8]].read(read: .words), [Array("ee".utf8), Array("ff".utf8)])
      XCTAssertEqual([[String]].stdin(read: .words, rows: 2), [[], ["last", "row"]])
      XCTAssertThrowsError(try String.read(read: .line))
    }).inputOnly("a b\nc d\ne f\naa bb  \ncc dd\nee ff\n\nlast row\n")
  }

  func testExplicitTextRowsAndWords() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(try [String].read(read: .line, rows: 2), ["a b", ""])
      XCTAssertEqual([[Character]].stdin(read: .line, rows: 1), [Array("c d")])
      XCTAssertEqual(try [[UInt8]].read(read: .line, rows: 1), [Array("e f".utf8)])
      XCTAssertEqual(String.stdin(read: .word), "tail")
      XCTAssertEqual(try [Character].read(read: .word), Array("word"))
      XCTAssertEqual([UInt8].stdin(read: .word), Array("bytes".utf8))
    }).inputOnly("a b\n\nc d\ne f\ntail word bytes\n")
  }
}
