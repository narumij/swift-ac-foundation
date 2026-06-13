import IOReader
import TestingUtil
import XCTest

// MARK: - String stdin Properties

final class ReaderStringStdinPropertyTests: XCTestCase {
  func testStringProperties() throws {
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
  }

  func testCharacterArrayProperties() throws {
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
  }

  func testUInt8ArrayProperties() throws {
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
  }
}

// MARK: - String stdin(columns:)

final class ReaderStringStdinColumnsFunctionTests: XCTestCase {
  func testSingleColumnString() throws {
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
  }

  func testStringColumns() throws {
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
  }

  func testCharacterArrayColumns() throws {
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
  }

  func testUInt8ArrayColumns() throws {
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
  }
}

// MARK: - String stdin(rows:)

final class ReaderStringStdinRowsFunctionTests: XCTestCase {
  func testStringRows() throws {
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
  }

  func testCharacterArrayRows() throws {
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
  }

  func testUInt8ArrayRows() throws {
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
  }
}

// MARK: - String stdin(rows:columns:)

final class ReaderStringStdinRowsColumnsFunctionTests: XCTestCase {
  func testStringRowsColumns() throws {
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

  func testCharacterArrayRowsColumns() throws {
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

  func testUInt8ArrayRowsColumns() throws {
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
