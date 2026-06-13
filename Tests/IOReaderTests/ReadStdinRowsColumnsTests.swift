import IOReader
import TestingUtil
import XCTest

private func string(from bytes: [UInt8]) -> String {
  String(bytes.map { Character(UnicodeScalar($0)) })
}

final class ReadStdinRowsColumnsTests: XCTestCase {
  func testUInt8RowsColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let CC: [[UInt8]] = .stdin(rows: 3, columns: 3)
        CC.forEach {
          print(string(from: $0).uppercased())
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
      AAA
      BBB
      CCC
      """)
  }

  func testStringRowsColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [String] = .stdin(rows: 3, columns: 3)
        SS.forEach {
          print($0.uppercased())
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
      AAA
      BBB
      CCC
      """)
  }

  func testIntRowsColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let ABC: [[Int]] = .stdin(rows: 3, columns: 3)
        ABC.forEach {
          print($0.map { $0 * 3 }.map(\.description).joined(separator: " "))
        }
      })
      .run(
        input:
          """
          1 1 1
          2 2 2
          3 3 3
          """),

      """
      3 3 3
      6 6 6
      9 9 9
      """)
  }

  func testIntRowsColumnsInNestedArray() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Int]] = .stdin(rows: 2, columns: 3)
        XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
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

  func testUIntRowsColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt]] = .stdin(rows: 2, columns: 3)
        XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
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

  func testDoubleRowsColumns() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Double]] = .stdin(rows: 2, columns: 3)
        XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
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
}
