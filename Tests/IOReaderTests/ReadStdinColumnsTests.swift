import IOReader
import TestingUtil
import XCTest

final class ReadStdinColumnsTests: XCTestCase {
  
  func testSingleStringColumn() throws {
    try SolverRunner(solver: {
      let SS: [String] = [.stdin(columns: 1)]
      XCTAssertEqual(SS, ["a"])
    })
    .inputOnly(
      """
      a
      """)
  }

  func testStringColumns() throws {
    try SolverRunner(solver: {
      let SS: [String] = [.stdin(columns: 3), .stdin(columns: 3), .stdin(columns: 3)]
      XCTAssertEqual(SS, ["aaa", "bbb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bbb
      ccc
      """)
  }

  func testCharacterArrayColumns() throws {
    try SolverRunner(solver: {
      let SS: [[Character]] = [.stdin(columns: 3), .stdin(columns: 3), .stdin(columns: 3)]
      XCTAssertEqual(SS.map { String($0) }, ["aaa", "bbb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bbb
      ccc
      """)
  }

  func testUInt8ArrayColumns() throws {
    try SolverRunner(solver: {
      let SS: [[UInt8]] = [.stdin(columns: 3), .stdin(columns: 3), .stdin(columns: 3)]
      XCTAssertEqual(SS.map { String(bytes: $0, encoding: .ascii) }, ["aaa", "bbb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bbb
      ccc
      """)
  }

  func testIntColumns() throws {
    try SolverRunner(solver: {
      let SS: [[Int]] = [.stdin(columns: 3), .stdin(columns: 3)]
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testUIntColumns() throws {
    try SolverRunner(solver: {
      let SS: [[UInt]] = [.stdin(columns: 3), .stdin(columns: 3)]
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testDoubleColumns() throws {
    try SolverRunner(solver: {
      let SS: [[Double]] = [.stdin(columns: 3), .stdin(columns: 3)]
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }
}
