import Convenience
import XCTest
import Algorithms
import TestingUtil

final class CovenienceTests: XCTestCase {

  func testPrefixSum() throws {
    XCTAssertEqual(prefixSum((1...5) + []), (1...5).reductions(0, +))
  }
  
  @available(macOS 26.0, *)
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
      .run(
        input: ""),

      """
      3 3 3
      1,2,3
      3 3 3 - 1 2 3
      """)
  }
}
