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
      let A = modint998244353.stdin
      XCTAssertEqual(A, 3)
      let B = modint998244353.stdin
      XCTAssertEqual(B, -1)
      XCTAssertEqual(B.val, modint998244353.mod - 1)
    })
    .run(
      input:
        """
        3
        -1
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
}
