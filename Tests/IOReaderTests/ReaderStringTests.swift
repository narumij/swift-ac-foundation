import IOReader
import Pack
import TestingUtil
import UInt8Util
import XCTest

final class ReaderStringTests: XCTestCase {
  func testStrings1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [String] = [.stdin(columns: 1)]
        XCTAssertEqual(SS, ["a"])
      })
      .run(
        input:
          """
          a
          """),

      """
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [String] = [.stdin, .stdin, .stdin]
        XCTAssertEqual(SS, ["aaa", "bb", "ccc"])
      })
      .run(
        input:
          """
          aaa
          bb
          ccc
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [String] = [.stdin(columns: 3), .stdin(columns: 3), .stdin(columns: 3)]
        XCTAssertEqual(SS, ["aaa", "bbb", "ccc"])
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
        let SS: [String] = .stdin(rows: 3)
        XCTAssertEqual(SS, ["aaa", "bb", "ccc"])
      })
      .run(
        input:
          """
          aaa
          bb
          ccc
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [String] = .stdin(rows: 3, columns: 3)
        XCTAssertEqual(SS, ["aaa", "bbb", "ccc"])
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

  func testStrings2() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Character]] = [.stdin, .stdin, .stdin]
        XCTAssertEqual(SS, ["aaa", "bb", "ccc"].map { $0.map { $0 } })
      })
      .run(
        input:
          """
          aaa
          bb
          ccc
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Character]] = [.stdin(columns: 3), .stdin(columns: 3), .stdin(columns: 3)]
        XCTAssertEqual(SS, ["aaa", "bbb", "ccc"].map { $0.map { $0 } })
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
        let SS: [[Character]] = .stdin(rows: 3)
        XCTAssertEqual(SS, ["aaa", "bb", "ccc"].map { $0.map { $0 } })
      })
      .run(
        input:
          """
          aaa
          bb
          ccc
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Character]] = .stdin(rows: 3, columns: 3)
        XCTAssertEqual(SS, ["aaa", "bbb", "ccc"].map { $0.map { $0 } })
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

  func testStrings3() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt8]] = [.stdin, .stdin, .stdin]
        XCTAssertEqual(SS, ["aaa", "bb", "ccc"].map { $0.compactMap { $0.asciiValue } })
      })
      .run(
        input:
          """
          aaa
          bb
          ccc
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt8]] = [.stdin(columns: 3), .stdin(columns: 3), .stdin(columns: 3)]
        XCTAssertEqual(SS, ["aaa", "bbb", "ccc"].map { $0.compactMap { $0.asciiValue } })
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
        let SS: [[UInt8]] = .stdin(rows: 3)
        XCTAssertEqual(SS, ["aaa", "bb", "ccc"].map { $0.compactMap { $0.asciiValue } })
      })
      .run(
        input:
          """
          aaa
          bb
          ccc
          """),

      """
      """)
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt8]] = .stdin(rows: 3, columns: 3)
        XCTAssertEqual(SS, ["aaa", "bbb", "ccc"].map { $0.compactMap { $0.asciiValue } })
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
}
