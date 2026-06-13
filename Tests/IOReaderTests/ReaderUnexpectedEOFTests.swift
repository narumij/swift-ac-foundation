import XCTest
import TestingUtil
import UInt8Util

#if DEBUG
  @testable import IOReader
  import Pack
#else
  import IOReader
  import Pack
#endif

final class ReaderUnexpectedEOFTests: XCTestCase {
  func testUnexpectedEOF1() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [Int].read(rows: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1
          2
          """),

      """
      """)
  }

  func testUnexpectedEOF2() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [Double].read(rows: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1
          2
          """),

      """
      """)
  }

  func testUnexpectedEOF3() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try String.read()) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          """),

      """
      """)
  }

  func testUnexpectedEOF4() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [UInt8].read()) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          """),

      """
      """)
  }

  func testUnexpectedEOF5() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String.read(columns: 4)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String].read(rows: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String].read(rows: 3, columns: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String].read(rows: 4, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)
  }

  func testUnexpectedEOF6() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[Character].read(columns: 4)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[Character]].read(rows: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[Character]].read(rows: 3, columns: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[Character]].read(rows: 4, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)
  }

  func testUnexpectedEOF7() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8].read(columns: 4)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8]].read(rows: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8]].read(rows: 3, columns: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8]].read(rows: 4, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          aaa
          bbb
          ccc
          """),
      """
      """)
  }

  func testUnexpectedEOF8() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(
          try [
            [Int.read(), Int.read(), Int.read(), Int.read()],
            [Int.read(), Int.read(), Int.read()],
          ]
        ) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(
          try [
            [Int].read(columns: 4),
            [Int].read(columns: 3),
          ]
        ) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),
      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[Int]].read(rows: 2, columns: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),

      """
      """)
  }

  func testUnexpectedEOF9() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(
          try [
            [Double.read(), Double.read(), Double.read(), Double.read()],
            [Double.read(), Double.read(), Double.read()],
          ]
        ) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(
          try [
            [Double].read(columns: 4),
            [Double].read(columns: 3),
          ]
        ) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),
      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[Double]].read(rows: 2, columns: 4)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
        }
      })
      .run(
        input:
          """
          1 2 3
          4 5 6
          """),

      """
      """)
  }

  func testUnexpectedEOF10() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String.read(columns: 3), String.read(columns: 3)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          c c
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String.read(columns: 3), String.read(columns: 3)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          a\ta
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String].read(rows: 2, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          a a
          bbb
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [String].read(rows: 2, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          b\tb
          """),
      """
      """)
  }

  func testUnexpectedEOF11() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8].read(columns: 3), [UInt8].read(columns: 3)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          c c
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8].read(columns: 3), [UInt8].read(columns: 3)]) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          a\ta
          ccc
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8]].read(rows: 2, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          a a
          bbb
          """),
      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [[UInt8]].read(rows: 2, columns: 3)) {
          XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedSpace)
        }
      })
      .run(
        input:
          """
          aaa
          b\tb
          """),
      """
      """)
  }
}
