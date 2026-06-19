import XCTest
import TestingUtil
import IOWriter
import UInt8Util

#if false
final class InlineTests: XCTestCase {

  @available(macOS 26.0, *)
  func testPrint2() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = InlineArray<3,Int>(repeating: 3)
        A.print()
        let B: InlineArray<3,Int> = [1,2,3]
        B.fastPrint(separator: Int32(" " as UInt8))
        A.fastPrint(terminator: Int32("-" as UInt8))
        B.fastPrint()
      })
      .outputOnly(),

      """
      3 3 3
      1,2,3
      3 3 3-1 2 3
      """)
  }
}
#endif
