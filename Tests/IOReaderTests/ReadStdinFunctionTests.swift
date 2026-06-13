import IOReader
import TestingUtil
import XCTest

final class ReadStdinFunctionTests: XCTestCase {
  func testStdinReadsIntegersUntilEndOfLine() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Int] = .stdin()
        let B: [Int] = .stdin()

        XCTAssertEqual(A, [1, 2, 3])
        XCTAssertEqual(B, [4, 5])
      })
      .run(
        input:
          """
          1 2 3
          4 5
          """),
      """
      """)
  }

  func testStdinReadsUnsignedIntegersUntilEndOfLine() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [UInt] = .stdin()
        let B: [UInt] = .stdin()

        XCTAssertEqual(A, [1, 2, 3])
        XCTAssertEqual(B, [4, 5])
      })
      .run(
        input:
          """
          1 2 3
          4 5
          """),
      """
      """)
  }

  func testStdinReadsDoublesUntilEndOfLine() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Double] = .stdin()
        let B: [Double] = .stdin()

        XCTAssertEqual(A, [1.5, 2.25, 3.75])
        XCTAssertEqual(B, [4.0, 5.5])
      })
      .run(
        input:
          """
          1.5 2.25 3.75
          4.0 5.5
          """),
      """
      """)
  }

  func testStdinReadsStringsUntilEndOfLine() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [String] = .stdin()
        let B: [String] = .stdin()

        XCTAssertEqual(A, ["Takahashi", "Aoki"])
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi
          """),
      """
      """)
  }

  func testStdinReadsCharacterArraysUntilEndOfLine() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[Character]] = .stdin()
        let B: [[Character]] = .stdin()

        XCTAssertEqual(A.map { String($0) }, ["Takahashi", "Aoki"])
        XCTAssertEqual(B.map { String($0) }, ["Tanaka", "Aoi"])
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi
          """),
      """
      """)
  }

  func testStdinReadsByteArraysUntilEndOfLine() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[UInt8]] = .stdin()
        let B: [[UInt8]] = .stdin()

        XCTAssertEqual(A.map { String(bytes: $0, encoding: .ascii) }, ["Takahashi", "Aoki"])
        XCTAssertEqual(B.map { String(bytes: $0, encoding: .ascii) }, ["Tanaka", "Aoi"])
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi
          """),
      """
      """)
  }
}
