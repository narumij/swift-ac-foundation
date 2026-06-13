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
      .outputOnly(),

      """
      3 3 3
      1,2,3
      3 3 3 - 1 2 3
      """)
  }

  func testPrint2() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        Array("Hello, world!").print()
        Array("Apple").print(separator: "-")
        Array("PenPinaple").print(terminator: "-")
        print("ApplePen")
      })
      .outputOnly(),

      """
      Hello, world!
      A-p-p-l-e
      PenPinaple-ApplePen
      """)
  }

  func testPrint3() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        "Hello, world!".unicodeScalars.map { UInt8($0.value) }.print()
        "Apple".unicodeScalars.map { UInt8($0.value) }.print(separator: "-")
        "PenPinaple".unicodeScalars.map { UInt8($0.value) }.print(terminator: "-")
        print("ApplePen")
      })
      .outputOnly(),

      """
      Hello, world!
      A-p-p-l-e
      PenPinaple-ApplePen
      """)
  }

  func testPrintNestedIntSequence() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        [[1, 2], [3, 4], [5]].print()
      })
      .outputOnly(),

      """
      1 2
      3 4
      5
      """)
  }

  func testPrintNestedCharacterSequence() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        [Array("Apple"), Array("Pen"), Array("Pineapple")].print()
      })
      .outputOnly(),

      """
      Apple
      Pen
      Pineapple
      """)
  }

  func testPrintNestedUInt8Sequence() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        [
          "Apple".utf8.map { $0 },
          "Pen".utf8.map { $0 },
          "Pineapple".utf8.map { $0 }
        ].print()
      })
      .outputOnly(),

      """
      Apple
      Pen
      Pineapple
      """)
  }

  func testPrintEmptySequence() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        [Int]().print()
        print("END")
      })
      .outputOnly(),

      """

      END
      """)
  }

  func testPrintEmptyNestedSequence() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        [[Int]]().print()
        print("END")
      })
      .outputOnly(),

      """
      END
      """)
  }
}
