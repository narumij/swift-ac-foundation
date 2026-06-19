import XCTest
import TestingUtil
import IOWriter

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

  @available(macOS 26.0, *)
  func testPrintNestedInlineArray() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let values: InlineArray<3, InlineArray<2, Int>> = [[1, 2], [3, 4], [5, 6]]
        values.print()
      })
      .outputOnly(),

      """
      1 2
      3 4
      5 6
      """)
  }

  @available(macOS 26.0, *)
  func testPrintNestedInlineArraySeparatorAndTerminator() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let values: InlineArray<2, InlineArray<3, Int>> = [[1, 2, 3], [4, 5, 6]]
        values.print(separator: ",", terminator: " | ")
        print("END")
      })
      .outputOnly(),

      """
      1,2,3 | 4,5,6 | END
      """)
  }

  @available(macOS 26.0, *)
  func testPrintTripleNestedInlineArray() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let values: InlineArray<2, InlineArray<2, InlineArray<2, Int>>> = [
          [[1, 2], [3, 4]],
          [[5, 6], [7, 8]],
        ]
        values.print()
      })
      .outputOnly(),

      """
      InlineArray<2, Int>(_storage: (Unknown)) InlineArray<2, Int>(_storage: (Unknown))
      InlineArray<2, Int>(_storage: (Unknown)) InlineArray<2, Int>(_storage: (Unknown))
      """)
  }

  @available(macOS 26.0, *)
  func testPrintCollectionOfInlineArray() throws {
    #if os(macOS) && !DEBUG
    // Filed as an Apple/Darwin Release-mode miscompile for Array<InlineArray<3, Int>>.
    throw XCTSkip("Skipped on macOS Release until the InlineArray miscompile is fixed.")
    #endif

    XCTAssertEqual(
      try SolverRunner(solver: {
        let values: [InlineArray<3, Int>] = [[1, 2, 3], [4, 5, 6]]
        values.print()
        values.print(separator: ",", terminator: " | ")
        print("END")
      })
      .outputOnly(),

      """
      1 2 3
      4 5 6
      1,2,3 | 4,5,6 | END
      """)
  }

  @available(macOS 26.0, *)
  func testPrintCollectionOfNestedInlineArray() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let values: [InlineArray<2, InlineArray<2, Int>>] = [
          [[1, 2], [3, 4]],
          [[5, 6], [7, 8]],
        ]
        values.print()
      })
      .outputOnly(),

      """
      InlineArray<2, Int>(_storage: (Unknown)) InlineArray<2, Int>(_storage: (Unknown))
      InlineArray<2, Int>(_storage: (Unknown)) InlineArray<2, Int>(_storage: (Unknown))
      """)
  }
}
