import IOReader
import TestingUtil
import XCTest

final class ReadStdinRowsColumnsTests: XCTestCase {
  func testUInt8RowsColumns() throws {
    try SolverRunner(solver: {
      let CC: [[UInt8]] = .stdin(rows: 3, columns: 3)
      XCTAssertEqual(CC.map { String(bytes: $0, encoding: .ascii) }, ["aaa", "bbb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bbb
      ccc
      """)
  }

  func testStringRowsColumns() throws {
    try SolverRunner(solver: {
      let SS: [String] = .stdin(rows: 3, columns: 3)
      XCTAssertEqual(SS, ["aaa", "bbb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bbb
      ccc
      """)
  }

  func testCharacterArrayRowsColumns() throws {
    try SolverRunner(solver: {
      let SS: [[Character]] = .stdin(rows: 3, columns: 3)
      XCTAssertEqual(SS.map { String($0) }, ["aaa", "bbb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bbb
      ccc
      """)
  }

  func testIntRowsColumns() throws {
    try SolverRunner(solver: {
      let ABC: [[Int]] = .stdin(rows: 3, columns: 3)
      XCTAssertEqual(ABC, [[1, 1, 1], [2, 2, 2], [3, 3, 3]])
    })
    .inputOnly(
      """
      1 1 1
      2 2 2
      3 3 3
      """)
  }

  func testIntRowsColumnsInNestedArray() throws {
    try SolverRunner(solver: {
      let SS: [[Int]] = .stdin(rows: 2, columns: 3)
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testUIntRowsColumns() throws {
    try SolverRunner(solver: {
      let SS: [[UInt]] = .stdin(rows: 2, columns: 3)
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testDoubleRowsColumns() throws {
    try SolverRunner(solver: {
      let SS: [[Double]] = .stdin(rows: 2, columns: 3)
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }
}
