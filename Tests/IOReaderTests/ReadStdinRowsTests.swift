import IOReader
import TestingUtil
import XCTest

final class ReadStdinRowsTests: XCTestCase {
  
  func testIntRows() throws {
    try SolverRunner(solver: {
      let A: [Int] = .stdin(rows: 3)
      XCTAssertEqual(A, [1, 2, 3])
    })
    .inputOnly(
      """
      1
      2
      3
      """)
  }

  func testScalarRowsReadsFixedNumberOfValues() throws {
    try SolverRunner(solver: {
      let A: [Int] = .stdin(rows: 2)
      let B: [Int] = .stdin()

      XCTAssertEqual(A, [1, 2])
      XCTAssertEqual(B, [3, 4, 5])
    })
    .inputOnly(
      """
      1
      2
      3 4 5
      """)
  }

  func testStringRowsReadsGridLines() throws {
    try SolverRunner(solver: {
      let SS: [String] = .stdin(rows: 3)
      let rest: [String] = .stdin()

      XCTAssertEqual(SS, ["#####", "#...#", "#####"])
      XCTAssertEqual(rest, ["done"])
    })
    .inputOnly(
      """
      #####
      #...#
      #####
      done
      """)
  }

  func testCharacterArrayRowsReadsGridLines() throws {
    try SolverRunner(solver: {
      let CC: [[Character]] = .stdin(rows: 3)
      let rest: [String] = .stdin()

      XCTAssertEqual(CC.map { String($0) }, ["#####", "#...#", "#####"])
      XCTAssertEqual(rest, ["done"])
    })
    .inputOnly(
      """
      #####
      #...#
      #####
      done
      """)
  }

  func testByteArrayRowsReadsGridLines() throws {
    try SolverRunner(solver: {
      let CC: [[UInt8]] = .stdin(rows: 3)
      let rest: [String] = .stdin()

      XCTAssertEqual(CC.map { String(bytes: $0, encoding: .ascii) }, ["#####", "#...#", "#####"])
      XCTAssertEqual(rest, ["done"])
    })
    .inputOnly(
      """
      #####
      #...#
      #####
      done
      """)
  }

  func testNestedIntRowsReadsPhysicalLines() throws {
    try SolverRunner(solver: {
      let A: [[Int]] = .stdin(rows: 2)
      let B: [Int] = .stdin()

      XCTAssertEqual(A, [[1, 2, 3], [4, 5]])
      XCTAssertEqual(B, [6])
    })
    .inputOnly(
      """
      1 2 3
      4 5
      6
      """)
  }
}
