import IOReader
import Pack
import TestingUtil
import UInt8Util
import XCTest

extension Array where Element == UInt8 {
  fileprivate var characters: [Character] { map { Character(UnicodeScalar($0)) } }
}

final class ReaderStdinTests: XCTestCase {
  func testRead1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let N = Int.stdin
        let F = Double.stdin
        XCTAssertEqual(F, 3.14)
        let S = String.stdin
        let CC = [UInt8].stdin
        let C0 = UInt8.stdin
        let C1 = UInt8.stdin
        print((N + 1))
        print((F * 2))
        print(S.uppercased())
        print(String(CC.characters + "1"))
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

  func testRead2() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let S: String = .stdin
        let CC: [UInt8] = .stdin
        print(S.uppercased())
        print(String(CC.characters + "1"))
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

  func testRead3() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let CC: [[UInt8]] = .stdin(rows: 3, columns: 3)
        CC.forEach {
          print(String($0.characters).uppercased())
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

  func testRead4() throws {
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

  func testRead5() throws {
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

  func testRead6() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Int] = .stdin(rows: 3)
        A.forEach {
          print($0 * 3)
        }
      })
      .run(
        input:
          """
          1
          2
          3
          """),

      """
      3
      6
      9
      """)
  }

  func testInt() throws {

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
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Int]] = [.stdin(columns: 3), .stdin(columns: 3)]
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

  func testIntRandom() throws {

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

  func testUInt() throws {

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
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[UInt]] = [.stdin(columns: 3), .stdin(columns: 3)]
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

  func testUIntRandom() throws {

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

  func testDouble() throws {
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
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Double]] = [.stdin(columns: 3), .stdin(columns: 3)]
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

  func testDoubleRandom() throws {

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
