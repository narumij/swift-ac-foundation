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
      XCTAssertThrowsError(try Int.read())
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
      XCTAssertThrowsError(try Int.read())
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
      XCTAssertThrowsError(try Double.read())
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
      XCTAssertThrowsError(try Double.read())
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
      XCTAssertThrowsError(try String.read(columns: 14))
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
      XCTAssertThrowsError(try String.read())
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 13))
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
      XCTAssertThrowsError(try String.read())
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 13))
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
      XCTAssertThrowsError(try [UInt8].read(columns: 14))
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
      XCTAssertThrowsError(try [UInt8].read())
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 13))
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
      XCTAssertThrowsError(try [UInt8].read())
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 13))
    }
  }

  func testRead1() throws {
    XCTAssertEqual(
      SolverRunner(solver: {
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
      SolverRunner(solver: {
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
      SolverRunner(solver: {
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
      SolverRunner(solver: {
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
      SolverRunner(solver: {
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
      SolverRunner(solver: {
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

  #if TEST_FATAL_ERROR
    func testUnexpectedEOF1() throws {

      XCTAssertEqual(
        SolverRunner(solver: {
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
            """),

        """
        3
        6
        """)
    }

    func testUnexpectedEOF2() throws {

      XCTAssertEqual(
        SolverRunner(solver: {
          let A: [Double] = .stdin(rows: 3)
          A.forEach {
            print($0 * 3)
          }
        })
        .run(
          input:
            """
            1
            2
            """),

        """
        3
        6
        """)
    }
  #endif

  func testUnexpectedEOF3() throws {

    XCTAssertEqual(
      SolverRunner(solver: {
        let A: String = .stdin
        print(A)
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
      SolverRunner(solver: {
        let A: [UInt8] = .stdin
        print(String(bytes: A, encoding: .ascii)!)
      })
      .run(
        input:
          """
          """),

      """
      """)
  }
  
  func testReadLine() throws {

    XCTAssertEqual(
      SolverRunner(solver: {
        let A: [Int] = .readLine()!
        print(A)
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10
          """),

      """
      [1, 2, 3, 4, 5]
      """)
    
    XCTAssertEqual(
      SolverRunner(solver: {
        let A: [Double] = .readLine()!
        print(A)
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10
          """),

      """
      [1.0, 2.0, 3.0, 4.0, 5.0]
      """)
    
    XCTAssertEqual(
      SolverRunner(solver: {
        let A: [String] = .readLine()!
        print(A)
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi
          """),

      """
      ["Takahashi", "Aoki"]
      """)
    
    XCTAssertEqual(
      SolverRunner(solver: {
        let A: [[UInt8]] = .readLine()!
        print(A.map{ String(bytes: $0, encoding: .ascii)! })
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi
          """),

      """
      ["Takahashi", "Aoki"]
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
