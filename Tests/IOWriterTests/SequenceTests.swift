import IOWriter
import TestingUtil
import XCTest

final class SequenceTests: XCTestCase {

  func testPrint1() throws {
    XCTAssertEqual(
      try SolverRunner {
        let A = [Int](repeating: 3, count: 3)
        A.print()
        let B = [1, 2, 3]
        B.print(separator: ",")
        A.print(terminator: " - ")
        B.print()
      }
      .outputOnly(),

      """
      3 3 3
      1,2,3
      3 3 3 - 1 2 3
      """)
  }

  func testPrint2() throws {
    XCTAssertEqual(
      try SolverRunner {
        Array("Hello, world!").print()
        Array("Apple").print(separator: "-")
        Array("PenPinaple").print(terminator: "-")
        print("ApplePen")
      }
      .outputOnly(),

      """
      Hello, world!
      A-p-p-l-e
      PenPinaple-ApplePen
      """)
  }

  func testPrint3() throws {
    XCTAssertEqual(
      try SolverRunner {
        "Hello, world!".unicodeScalars.map { UInt8($0.value) }.print()
        "Apple".unicodeScalars.map { UInt8($0.value) }.print(separator: "-")
        "PenPinaple".unicodeScalars.map { UInt8($0.value) }.print(terminator: "-")
        print("ApplePen")
      }
      .outputOnly(),

      """
      Hello, world!
      A-p-p-l-e
      PenPinaple-ApplePen
      """)
  }

  func testPrintNestedIntSequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        [[1, 2], [3, 4], [5]].print()
      }
      .outputOnly(),

      """
      1 2
      3 4
      5
      """)
  }

  func testPrintNestedCharacterSequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        [Array("Apple"), Array("Pen"), Array("Pineapple")].print()
      }
      .outputOnly(),

      """
      Apple
      Pen
      Pineapple
      """)
  }

  func testPrintNestedUInt8Sequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        [
          "Apple".utf8.map { $0 },
          "Pen".utf8.map { $0 },
          "Pineapple".utf8.map { $0 },
        ].print()
      }
      .outputOnly(),

      """
      Apple
      Pen
      Pineapple
      """)
  }

  func testPrintEmptySequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        [Int]().print()
        print("END")
      }
      .outputOnly(),

      """

      END
      """)
  }

  func testPrintEmptyNestedSequence() throws {
    XCTAssertEqual(
      try SolverRunner {
        [[Int]]().print()
        print("END")
      }
      .outputOnly(),

      """
      END
      """)
  }

  func testPrintFloatingPoint() throws {
    XCTAssertEqual(
      try SolverRunner {
        let A = [1.5, 2.5, 3.5]
        A.print()

        let B = [1.25, 2.5, 3.75]
        B.print(separator: ",")

        A.print(terminator: " - ")
        B.print()
      }
      .outputOnly(),

      """
      1.5 2.5 3.5
      1.25,2.5,3.75
      1.5 2.5 3.5 - 1.25 2.5 3.75
      """)
  }

  func testPrintNestedFloatingPoint() throws {
    XCTAssertEqual(
      try SolverRunner {
        [
          [1.5, 2.5],
          [3.5, 4.5],
          [5.5],
        ].print()
      }
      .outputOnly(),

      """
      1.5 2.5
      3.5 4.5
      5.5
      """)
  }

  func testPrintNestedFloatingPointSeparator() throws {
    XCTAssertEqual(
      try SolverRunner {
        [
          [1.5, 2.5],
          [3.5, 4.5],
        ].print(separator: ",")
      }
      .outputOnly(),

      """
      1.5,2.5
      3.5,4.5
      """)
  }
}
