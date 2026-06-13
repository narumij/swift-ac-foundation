import IOReader
import TestingUtil
import XCTest

final class ReadStdinRowsTests: XCTestCase {
  func testIntRows() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Int] = .stdin(rows: 3)
        A.forEach {
          print($0 * 3)
        }
      })
      .run(
        input:
          """
          1
          2
          3
          """),

      """
      3
      6
      9
      """)
  }
}
