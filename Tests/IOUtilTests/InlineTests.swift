import XCTest
import TestingUtil
import IOUtil

final class InlineTests: XCTestCase {

  @available(macOS 26.0, *)
  func testPrint2() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = InlineArray<3,Int>(repeating: 3)
        A.print()
        let B: InlineArray<3,Int> = [1,2,3]
        B.print(separator: ",")
        A.print(terminator: " - ")
        B.print()
      })
      .outputOnly(),

      """
      3 3 3
      1,2,3
      3 3 3 - 1 2 3
      """)
  }
}
