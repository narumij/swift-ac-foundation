import XCTest
import TestingUtil
import IOUtil

final class SequenceTests: XCTestCase {

  func testPrint1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = [Int](repeating: 3, count: 3)
        A.print()
        let B = [1, 2, 3]
        B.print(separator: ",")
        A.print(terminator: " - ")
        B.print()
      })
      .run(
        input: ""),

      """
      3 3 3
      1,2,3
      3 3 3 - 1 2 3
      """)
  }
}
