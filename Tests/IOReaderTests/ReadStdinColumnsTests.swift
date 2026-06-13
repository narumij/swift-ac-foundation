import IOReader
import TestingUtil
import XCTest

final class ReadStdinColumnsTests: XCTestCase {
  func testIntColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Int]] = [.stdin(columns: 3), .stdin(columns: 3)]
        XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),
      """
      """)
  }

  func testUIntColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt]] = [.stdin(columns: 3), .stdin(columns: 3)]
        XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),
      """
      """)
  }

  func testDoubleColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Double]] = [.stdin(columns: 3), .stdin(columns: 3)]
        XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),
      """
      """)
  }
}
