//
//  CxxInteropTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/06/20.
//

import CxxWrapped
import XCTest

final class CxxWrappedTests: XCTestCase {

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testExample() throws {
    XCTAssertEqual(gcd(12, 16), 4 as Int)
    XCTAssertEqual(gcd(12, 16), 4 as UInt)
    XCTAssertEqual(lcm(12, 16), 48 as Int)
    XCTAssertEqual(lcm(12, 16), 48 as UInt)
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
