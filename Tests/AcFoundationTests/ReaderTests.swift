//
//  ReadTests.swift
//
//
//  Created by narumij on 2023/12/18.
//

import XCTest

#if DEBUG
  @testable import AcFoundation
#else
  import AcFoundation
#endif

extension Int8: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {}
extension Int8: @retroactive ExpressibleByUnicodeScalarLiteral {}
extension CChar: @retroactive ExpressibleByStringLiteral {
  public init(stringLiteral s: String) {
    self = Character(s).asciiValue.map { Int8($0) }!
  }
}

extension Array where Element == UInt8 {
  var characters: [Character] { map { Character(UnicodeScalar($0)) } }
}

extension Int128: ArrayReadable & LineReadable {}
extension UInt128: ArrayReadable & LineReadable {}

final class ReaderTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testOneLineFixtureInt() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineInt.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try Int.read()
      XCTAssertEqual(N, 1000)
    }
  }

  func testSpacesFixtureInt() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Int.read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureInt() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Int.read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureDouble() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineDouble.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try Double.read()
      XCTAssertEqual(N, 0.1234, accuracy: 0.0001)
    }
  }

  func testSpacesFixtureDouble() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Double.read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureDouble() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Double.read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureString() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineString.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try String.read()
      XCTAssertEqual(N, "TakahashiAoki")
    }

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try String.read(columns: 13)
      XCTAssertEqual(N, "TakahashiAoki")
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 14)) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testSpacesFixtureString() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 13)) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureString() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 13)) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureBytes() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineString.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try [UInt8].read()
      XCTAssertEqual(N, "TakahashiAoki".compactMap(\.asciiValue))
    }

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try [UInt8].read(columns: 13)
      XCTAssertEqual(N, "TakahashiAoki".compactMap(\.asciiValue))
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 14)) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testSpacesFixtureBytes() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 13)) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureBytes() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read()) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 13)) {
        XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
      }
    }
  }

  func testRead1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let N = Int.stdin
        let F = Double.stdin
        assert(F == 3.14)
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
  
  func testUInt() throws {
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt.stdin)
      })
      .run(
        input:
          """
          \(UInt.max)
          """),
      """
      \(Int.max)
      """)
    throw XCTSkip("atolの制限で以下への未対応は制限事項となる。上記のようにInt.maxに丸められます。")
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt.stdin)
      })
      .run(
        input:
          """
          \(UInt.max)
          """),
      """
      \(UInt.max)
      """)
  }
  
  func testInt128() throws {
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(Int128.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          """),
      """
      \(Int.max)
      """)
    throw XCTSkip("atolの制限で以下への未対応は制限事項となる。上記のようにInt.maxに丸められます。")
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt128.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          """),
      """
      \(Int128.max)
      """)
  }
  
  func testUInt128() throws {
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt128.stdin)
      })
      .run(
        input:
          """
          \(UInt128.max)
          """),
      """
      \(Int.max)
      """)
    throw XCTSkip("atolの制限で以下への未対応は制限事項となる。上記のようにInt.maxに丸められます。")
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt128.stdin)
      })
      .run(
        input:
          """
          \(UInt128.max)
          """),
      """
      \(UInt128.max)
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
        let SS: [[Int]] = [[.stdin,.stdin,.stdin],[.stdin,.stdin,.stdin]]
        XCTAssertEqual(SS, [[1,2,3],[4,5,6]])
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
        let SS: [[Int]] = [.stdin(columns: 3),.stdin(columns: 3)]
        XCTAssertEqual(SS, [[1,2,3],[4,5,6]])
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
        XCTAssertEqual(SS, [[1,2,3],[4,5,6]])
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
  
  func testDouble() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [[Double]] = [[.stdin,.stdin,.stdin],[.stdin,.stdin,.stdin]]
        XCTAssertEqual(SS, [[1,2,3],[4,5,6]])
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
        let SS: [[Double]] = [.stdin(columns: 3),.stdin(columns: 3)]
        XCTAssertEqual(SS, [[1,2,3],[4,5,6]])
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
        XCTAssertEqual(SS, [[1,2,3],[4,5,6]])
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
        let SS: [String] = [.stdin,.stdin,.stdin]
        XCTAssertEqual(SS, ["aaa","bb","ccc"])
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
        let SS: [String] = [.stdin(columns: 3),.stdin(columns: 3),.stdin(columns: 3)]
        XCTAssertEqual(SS, ["aaa","bbb","ccc"])
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
        XCTAssertEqual(SS, ["aaa","bb","ccc"])
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
        XCTAssertEqual(SS, ["aaa","bbb","ccc"])
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
        let SS: [[Character]] = [.stdin,.stdin,.stdin]
        XCTAssertEqual(SS, ["aaa","bb","ccc"].map{ $0.map{ $0 } })
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
        let SS: [[Character]] = [.stdin(columns: 3),.stdin(columns: 3),.stdin(columns: 3)]
        XCTAssertEqual(SS, ["aaa","bbb","ccc"].map{ $0.map{ $0 } })
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
        XCTAssertEqual(SS, ["aaa","bb","ccc"].map{ $0.map{ $0 } })
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
        XCTAssertEqual(SS, ["aaa","bbb","ccc"].map{ $0.map{ $0 } })
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
        let SS: [[UInt8]] = [.stdin,.stdin,.stdin]
        XCTAssertEqual(SS, ["aaa","bb","ccc"].map{ $0.compactMap{ $0.asciiValue } })
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
        let SS: [[UInt8]] = [.stdin(columns: 3),.stdin(columns: 3),.stdin(columns: 3)]
        XCTAssertEqual(SS, ["aaa","bbb","ccc"].map{ $0.compactMap{ $0.asciiValue } })
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
        XCTAssertEqual(SS, ["aaa","bb","ccc"].map{ $0.compactMap{ $0.asciiValue } })
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
        XCTAssertEqual(SS, ["aaa","bbb","ccc"].map{ $0.compactMap{ $0.asciiValue } })
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

  func testUnexpectedEOF1() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        XCTAssertThrowsError(try [Int].read(rows: 3)) {
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
        XCTAssertThrowsError(try [
          [Int.read(),Int.read(),Int.read(),Int.read()],
          [Int.read(),Int.read(),Int.read()]]) {
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
        XCTAssertThrowsError(try [
          [Int].read(columns: 4),
          [Int].read(columns: 3)]) {
            XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
        XCTAssertThrowsError(try [
          [Double.read(),Double.read(),Double.read(),Double.read()],
          [Double.read(),Double.read(),Double.read()]]) {
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
        XCTAssertThrowsError(try [
          [Double].read(columns: 4),
          [Double].read(columns: 3)]) {
            XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedEOF)
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
        XCTAssertThrowsError(try [String.read(columns: 3),String.read(columns: 3)]) {
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
        XCTAssertThrowsError(try [String.read(columns: 3),String.read(columns: 3)]) {
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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
          XCTAssertEqual($0 as? IOReader.Error, IOReader.Error.unexpectedSpace)
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

  func testReadLine() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Int] = .readLine()!
        print(A)
        let B: [Int] = (0..<5).map { _ in .stdin }
        XCTAssertEqual(B, [6, 7, 8, 9, 10])
        let C: [Int] = .readLine()!
        XCTAssertEqual(C, [11, 12])
        XCTAssertNil([Int].readLine())
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10 11 12
          """),

      """
      [1, 2, 3, 4, 5]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Double] = .readLine()!
        print(A)
        let B: [Int] = (0..<5).map { _ in .stdin }
        XCTAssertEqual(B, [6, 7, 8, 9, 10])
        let C: [Double] = .readLine()!
        XCTAssertEqual(C, [11, 12])
        XCTAssertNil([Int].readLine())
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10 11 12
          """),

      """
      [1.0, 2.0, 3.0, 4.0, 5.0]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [String] = .readLine()!
        print(A)
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = .readLine()!
        XCTAssertEqual(C, ["Foo", "Bar"])
        XCTAssertNil([String].readLine())
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[Character]] = .readLine()!
        print(A.map { String($0) })
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = .readLine()!
        XCTAssertEqual(C, ["Foo", "Bar"])
        XCTAssertNil([[UInt8]].readLine())
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[UInt8]] = .readLine()!
        print(A.map { String(bytes: $0, encoding: .ascii)! })
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = .readLine()!
        XCTAssertEqual(C, ["Foo", "Bar"])
        XCTAssertNil([[UInt8]].readLine())
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = String(bytes: [UInt8].readLine()!, encoding: .ascii)!
        let B = String([Character].readLine()!)
        print(A)
        print(B)
        XCTAssertEqual(A, "Takahashi Aoki")
        XCTAssertEqual(B, "Tanaka Aoi Foo Bar")
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      Takahashi Aoki
      Tanaka Aoi Foo Bar
      """)
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = String([Character].readLine()!)
        let B = String(bytes: [UInt8].readLine()!, encoding: .ascii)!
        print(A)
        print(B)
        XCTAssertEqual(A, "Takahashi Aoki")
        XCTAssertEqual(B, "Tanaka Aoi Foo Bar")
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      Takahashi Aoki
      Tanaka Aoi Foo Bar
      """)
  }

  #if DEBUG
    let stringFixtureA = ""
    let stringFixtureB = ""
  #else
    let stringFixtureA = String(
      (0..<5_000_000).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
    let stringFixtureB = String(
      (0..<5_000_000).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
  #endif

  func testPerformanceCChar1() throws {

    // This is an example of a performance test case.
    let a: [UInt8] = stringFixtureA.compactMap(\.asciiValue)
    let b: [UInt8] = stringFixtureB.compactMap(\.asciiValue)
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      for i in 0..<min(a.count, b.count) {
        c += a[i] == b[i] ? 1 : -1
      }
    }
  }

  func testPerformanceCharacter1() throws {

    // This is an example of a performance test case.
    let a = stringFixtureA.map { $0 }
    let b = stringFixtureB.map { $0 }
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      for i in 0..<min(a.count, b.count) {
        c += a[i] == b[i] ? 1 : -1
      }
    }
  }

  let stringFixtureAA = (0..<500).map { _ in
    String((0..<500).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
  }
  let stringFixtureBB = (0..<500).map { _ in
    String((0..<500).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
  }

  func testPerformanceCChar2() throws {

    // This is an example of a performance test case.
    let a = stringFixtureAA.map { $0.compactMap(\.asciiValue) }
    let b = stringFixtureBB.map { $0.compactMap(\.asciiValue) }
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      let ii = (0..<500).shuffled()
      let jj = (0..<500).shuffled()
      for i in ii {
        for j in jj {
          c += a[i][j] == b[i][j] ? 1 : -1
        }
      }
    }
  }

  func testPerformanceCharacter2() throws {

    // This is an example of a performance test case.
    let a = stringFixtureAA.map { $0.map { $0 } }
    let b = stringFixtureBB.map { $0.map { $0 } }
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      let ii = (0..<500).shuffled()
      let jj = (0..<500).shuffled()
      for i in ii {
        for j in jj {
          c += a[i][j] == b[i][j] ? 1 : -1
        }
      }
    }
  }
}
