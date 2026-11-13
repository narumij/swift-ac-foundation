import IOReaderV2
import TestingUtil
import XCTest

final class ReaderTupleTests: XCTestCase {

  func testTuple1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let (A, B, C): (UInt8, [UInt8], Int) = stdin()
        print(String(bytes: [A], encoding: .ascii)!)
        print(String(bytes: B, encoding: .ascii)!)
        print(C)
      })
      .run(
        input:
          """
          A BB 111
          """),

      """
      A
      BB
      111
      """)
  }
}
