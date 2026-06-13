import IOReader
import TestingUtil
import XCTest

private func string(from bytes: [UInt8]) -> String {
  String(bytes.map { Character(UnicodeScalar($0)) })
}

final class ReadStdinPropertyTests: XCTestCase {
  
  func testMixedScalarAndAsciiProperties() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let N = Int.stdin
        let F = Double.stdin
        XCTAssertEqual(F, 3.14)
        let S = String.stdin
        let CC = [UInt8].stdin
        let C0 = UInt8.stdin
        let C1 = UInt8.stdin
        print(N + 1)
        print(F * 2)
        print(S.uppercased())
        print(string(from: CC) + "1")
        print(String(bytes: [C1], encoding: .ascii)!)
        print(String(bytes: [C0], encoding: .ascii)!)
      })
      .run(
        input:
          """
          3
          3.14
          abc
          1111
          Z Y
          """),

      """
      4
      6.28
      ABC
      11111
      Y
      Z
      """)
  }

  func testLongStringAndByteArrayProperties() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let S: String = .stdin
        let CC: [UInt8] = .stdin
        print(S.uppercased())
        print(string(from: CC) + "1")
      })
      .run(
        input:
          """
          abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
          1111111111111111111111111111111111111111111111111111
          """),

      """
      ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ
      11111111111111111111111111111111111111111111111111111
      """)
  }

  func testIntBoundaries() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(Int.stdin)
        print(Int.stdin)
      })
      .run(
        input:
          """
          \(Int.max)
          \(Int.min)
          """),
      """
      \(Int.max)
      \(Int.min)
      """)
  }

  func testIntPropertiesInNestedLiterals() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Int]] = [[.stdin, .stdin, .stdin], [.stdin, .stdin, .stdin]]
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

  func testRandomIntProperties() throws {
    for _ in 0..<1000 {
      let i = Int.random(in: Int.min...Int.max)
      _ = try SolverRunner(solver: {
        XCTAssertEqual(Int.stdin, i)
      })
      .run(
        input:
          """
          \(i)
          """)
    }
  }

  func testUIntBoundaries() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt.stdin)
        print(UInt.stdin)
      })
      .run(
        input:
          """
          \(UInt.max)
          \(UInt.min)
          """),
      """
      \(UInt.max)
      \(UInt.min)
      """)
  }

  func testUIntPropertiesInNestedLiterals() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt]] = [[.stdin, .stdin, .stdin], [.stdin, .stdin, .stdin]]
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

  func testRandomUIntProperties() throws {
    for _ in 0..<1000 {
      let i = UInt.random(in: UInt.min...UInt.max)
      _ = try SolverRunner(solver: {
        XCTAssertEqual(UInt.stdin, i)
      })
      .inputOnly(
        """
        \(i)
        """)
    }
  }

  func testDoublePropertiesInNestedLiterals() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Double]] = [[.stdin, .stdin, .stdin], [.stdin, .stdin, .stdin]]
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

  func testDoubleBoundaries() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [Double] = [.stdin, .stdin, .stdin, .stdin]
        XCTAssertEqual(
          SS,
          [
            Double.ulpOfOne, -Double.ulpOfOne, Double.greatestFiniteMagnitude,
            -Double.greatestFiniteMagnitude,
          ])
      })
      .run(
        input:
          """
          2.220446049250313e-16 -2.220446049250313e-16 1.7976931348623157e+308 -1.7976931348623157e+308
          """),
      """
      """)
  }

  func testRandomDoubleProperties() throws {
    for _ in 0..<1000 {
      let i = Double.random(in: Double(Int.min)...Double(Int.max))
      _ = try SolverRunner(solver: {
        XCTAssertEqual(Double.stdin, i)
      })
      .run(
        input:
          """
          \(i)
          """)
    }
  }
}
