import IOUtil
import TestingUtil
import XCTest

@available(macOS 26.0, *)
final class InlineArrayFastPrintTests: XCTestCase {

  func testFastPrintSignedIntegerInlineArray() throws {
    XCTAssertEqual(
      try SolverRunner {
        let values: InlineArray<3, Int32> = [-1, 0, 2]
        values.fastPrint(separator: ",", terminator: "!")
      }
      .outputOnly(),

      "-1,0,2!")
  }

  func testFastPrintUnsignedIntegerInlineArray() throws {
    XCTAssertEqual(
      try SolverRunner {
        let values: InlineArray<3, UInt16> = [4, 5, 6]
        values.fastPrint(separator: "|", terminator: ";")
      }
      .outputOnly(),

      "4|5|6;")
  }

  func testFastPrintSignedIntegerInlineArrayRows() throws {
    XCTAssertEqual(
      try SolverRunner {
        let rows: InlineArray<2, InlineArray<3, Int>> = [
          [1, 2, 3],
          [-4, -5, -6],
        ]
        rows.fastPrint(separator: ",", terminator: "!")
      }
      .outputOnly(),

      "1,2,3!-4,-5,-6!")
  }

  func testFastPrintUnsignedIntegerInlineArrayRows() throws {
    XCTAssertEqual(
      try SolverRunner {
        let rows: [InlineArray<2, UInt>] = [
          [7, 8],
          [9, 10],
        ]
        rows.fastPrint(separator: "-", terminator: ";")
      }
      .outputOnly(),

      "7-8;9-10;")
  }
}
