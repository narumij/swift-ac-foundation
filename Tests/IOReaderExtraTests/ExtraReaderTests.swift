//
//  ReadTests.swift
//
//
//  Created by narumij on 2023/12/18.
//

import AtCoder
import BigInt
import IOReaderExtra
import Pack
import TestingUtil
import XCTest

final class ExtraReaderTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testRead1() throws {
    _ = try SolverRunner(solver: {
      XCTAssertEqual(modint998244353.stdin, 0)
      XCTAssertEqual(modint998244353.stdin, 3)
      XCTAssertEqual(modint998244353.stdin.val, modint998244353.mod - 1)
      XCTAssertEqual(modint998244353.stdin.val, modint998244353.mod - 1)
      XCTAssertEqual(modint998244353.stdin.val, 0)
    })
    .run(
      input:
        """
        0
        3
        -1
        \(modint998244353.mod - 1)
        \(modint998244353.mod)
        """)
  }

  func testRead2() throws {
    _ = try SolverRunner(solver: {
      let A = BigInt.stdin
      XCTAssertEqual(A, 3)
      let B = BigInt.stdin
      XCTAssertEqual(B, -1)
    })
    .run(
      input:
        """
        3
        -1
        """)
  }

  @available(macOS 15.0, *)
  func testRead3() throws {
    _ = try SolverRunner(solver: {
      let A = UInt128.stdin
      XCTAssertEqual(A, 3)
      let B = Int128.stdin
      XCTAssertEqual(B, -1)
    })
    .run(
      input:
        """
        3
        -1
        """)
  }

  @available(macOS 15.0, *)
  func testInt128() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        print(Int128.stdin)
        print(Int128.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          \(Int128.min)
          """),
      """
      \(Int128.max)
      \(Int128.min)
      """)
  }

  @available(macOS 15.0, *)
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
      \(UInt128.max)
      """)
  }

  @available(macOS 15.0, *)
  func testBigInt() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        print(BigInt.stdin)
        print(BigInt.stdin)
        print(BigInt.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          \(Int128.min)
          \(UInt128.max)
          """),
      """
      \(Int128.max)
      \(Int128.min)
      \(UInt128.max)
      """)
  }

  func testPack() throws {
    if #available(macOS 14.0, *) {

      XCTAssertEqual(
        try SolverRunner(solver: {
          let A: Pack<Character, [Character], Double> = try .read()
          print(String([A.rawValue.0]))
          print(String(A.rawValue.1))
          print(A.rawValue.2)
        })
        .run(
          input:
            """
            A BB 111
            """),

        """
        A
        BB
        111.0
        """)
    }
  }

  func testPack2() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: Pack2<Character, [Character]> = try .read()
        print(String([A.rawValue.0]))
        print(String(A.rawValue.1))
      })
      .run(
        input:
          """
          A BB
          """),

      """
      A
      BB
      """)
  }

  func testPack3() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: Pack3<Character, [Character], Double> = try .read()
        print(String([A.rawValue.0]))
        print(String(A.rawValue.1))
        print(A.rawValue.2)
      })
      .run(
        input:
          """
          A BB 111
          """),

      """
      A
      BB
      111.0
      """)
  }
}
