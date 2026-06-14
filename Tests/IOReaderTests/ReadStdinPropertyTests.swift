import IOReader
import TestingUtil
import XCTest

final class ReadStdinPropertyTests: XCTestCase {
  
  func testStringProperties() throws {
    try SolverRunner(solver: {
      let SS: [String] = [.stdin, .stdin, .stdin]
      XCTAssertEqual(SS, ["aaa", "bb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bb
      ccc
      """)
  }

  func testCharacterArrayProperties() throws {
    try SolverRunner(solver: {
      let SS: [[Character]] = [.stdin, .stdin, .stdin]
      XCTAssertEqual(SS.map { String($0) }, ["aaa", "bb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bb
      ccc
      """)
  }

  func testUInt8ArrayProperties() throws {
    try SolverRunner(solver: {
      let SS: [[UInt8]] = [.stdin, .stdin, .stdin]
      XCTAssertEqual(SS.map { String(bytes: $0, encoding: .ascii) }, ["aaa", "bb", "ccc"])
    })
    .inputOnly(
      """
      aaa
      bb
      ccc
      """)
  }

  func testMixedScalarAndAsciiProperties() throws {
    try SolverRunner(solver: {
      let N = Int.stdin
      let F = Double.stdin
      let S = String.stdin
      let CC = [UInt8].stdin
      let C0 = UInt8.stdin
      let C1 = UInt8.stdin

      XCTAssertEqual(N, 3)
      XCTAssertEqual(F, 3.14)
      XCTAssertEqual(S, "abc")
      XCTAssertEqual(String(bytes: CC, encoding: .ascii), "1111")
      XCTAssertEqual(String(bytes: [C0], encoding: .ascii), "Z")
      XCTAssertEqual(String(bytes: [C1], encoding: .ascii), "Y")
    })
    .inputOnly(
      """
      3
      3.14
      abc
      1111
      Z Y
      """)
  }

  func testLongStringAndByteArrayProperties() throws {
    try SolverRunner(solver: {
      let S: String = .stdin
      let CC: [UInt8] = .stdin

      XCTAssertEqual(S, "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz")
      XCTAssertEqual(
        String(bytes: CC, encoding: .ascii),
        "1111111111111111111111111111111111111111111111111111")
    })
    .inputOnly(
      """
      abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
      1111111111111111111111111111111111111111111111111111
      """)
  }

  func testIntBoundaries() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int.stdin, Int.min)
    })
    .inputOnly(
      """
      \(Int.max)
      \(Int.min)
      """)
  }

  func testIntPropertiesInNestedLiterals() throws {
    try SolverRunner(solver: {
      let SS: [[Int]] = [[.stdin, .stdin, .stdin], [.stdin, .stdin, .stdin]]
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testRandomIntProperties() throws {
    for _ in 0..<1000 {
      let i = Int.random(in: Int.min...Int.max)
      try SolverRunner(solver: {
        XCTAssertEqual(Int.stdin, i)
      })
      .inputOnly(
        """
        \(i)
        """)
    }
  }

  func testUIntBoundaries() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, UInt.min)
    })
    .inputOnly(
      """
      \(UInt.max)
      \(UInt.min)
      """)
  }

  func testUIntPropertiesInNestedLiterals() throws {
    try SolverRunner(solver: {
      let SS: [[UInt]] = [[.stdin, .stdin, .stdin], [.stdin, .stdin, .stdin]]
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testRandomUIntProperties() throws {
    for _ in 0..<1000 {
      let i = UInt.random(in: UInt.min...UInt.max)
      try SolverRunner(solver: {
        XCTAssertEqual(UInt.stdin, i)
      })
      .inputOnly(
        """
        \(i)
        """)
    }
  }

  func testDoublePropertiesInNestedLiterals() throws {
    try SolverRunner(solver: {
      let SS: [[Double]] = [[.stdin, .stdin, .stdin], [.stdin, .stdin, .stdin]]
      XCTAssertEqual(SS, [[1, 2, 3], [4, 5, 6]])
    })
    .inputOnly(
      """
      1 2 3
      4 5 6
      """)
  }

  func testDoubleBoundaries() throws {
    try SolverRunner(solver: {
      let SS: [Double] = [.stdin, .stdin, .stdin, .stdin]
      XCTAssertEqual(
        SS,
        [
          Double.ulpOfOne, -Double.ulpOfOne, Double.greatestFiniteMagnitude,
          -Double.greatestFiniteMagnitude,
        ])
    })
    .inputOnly(
      """
      2.220446049250313e-16 -2.220446049250313e-16 1.7976931348623157e+308 -1.7976931348623157e+308
      """)
  }

  func testRandomDoubleProperties() throws {
    for _ in 0..<1000 {
      let i = Double.random(in: Double(Int.min)...Double(Int.max))
      try SolverRunner(solver: {
        XCTAssertEqual(Double.stdin, i)
      })
      .inputOnly(
        """
        \(i)
        """)
    }
  }
}
