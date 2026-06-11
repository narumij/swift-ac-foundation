//
//  ReadTests.swift
//
//
//  Created by narumij on 2023/12/18.
//

import XCTest
import TestingUtil
import AtCoder
import BigInt
import IOReaderExtra

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
}
