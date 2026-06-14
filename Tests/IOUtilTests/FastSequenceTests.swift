import IOUtil
import TestingUtil
import XCTest

final class FastSequenceTests: XCTestCase {

  func testFastPrintSignedIntegerSequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        [8, 9].fastPrint()
        AnySequence([-2, -1, 0, 1, 2]).fastPrint()
        stride(from: 3, through: 7, by: 2).fastPrint(separator: ",", terminator: "!")
      }
      .outputOnly(),

      """
      8 9
      -2 -1 0 1 2
      3,5,7!
      """)
  }

  func testFastPrintUnsignedIntegerSequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        AnySequence([1, 2, 3] as [UInt]).fastPrint()
        AnySequence([4, 5, 6] as [UInt32]).fastPrint(separator: "-", terminator: ";")
      }
      .outputOnly(),

      """
      1 2 3
      4-5-6;
      """)
  }

  func testFastPrintEmptySequenceProducesNoOutput() throws {
    XCTAssertEqual(
      try SolverRunner {
        AnySequence([Int]()).fastPrint()
        print("END")
      }
      .outputOnly(),

      """
      END
      """)
  }
}
