//
//  PackTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/06/18.
//

import Pack
import XCTest

final class PackTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testExample() throws {
    let p: Pack<Int, Int, Int> = .init(1, 2, 3)
    XCTAssertEqual(p.rawValue.0, 1)
    XCTAssertEqual(p.rawValue.1, 2)
    XCTAssertEqual(p.rawValue.2, 3)
    let a: [Pack<Int>: Int] = [.init(1): 1]
    let b: [Pack<Int, Int>: Int] = [.init(1, 1): 1]
    let c: [Pack<Int, Int, Int>: Int] = [.init(1, 1, 1): 1]
    let d: [Pack<Int, Int, Int, Int>: Int] = [.init(1, 1, 1, 1): 1]
    XCTAssertEqual(a[.init(1)], 1)
    XCTAssertEqual(b[.init(1, 1)], 1)
    XCTAssertEqual(c[.init(1, 1, 1)], 1)
    XCTAssertEqual(d[.init(1, 1, 1, 1)], 1)
    let e: [Pack<Int, UInt, String, Int>: Int] = [.init(1, 1, "", 1): 1]
  }

  func testCompare() throws {
    
    XCTAssertEqual((1,1) < (1,1), Pack(1,1) < Pack(1,1))
    XCTAssertEqual((1,2) < (2,1), Pack(1,2) < Pack(2,1))
    XCTAssertEqual((2,1) < (1,1), Pack(2,1) < Pack(1,1))
    XCTAssertEqual((2,1) < (2,1), Pack(2,1) < Pack(2,1))
    XCTAssertEqual((2,2) < (2,2), Pack(2,2) < Pack(2,2))
    XCTAssertEqual((1,2) < (1,3), Pack(1,2) < Pack(1,3))
    
    let a = [(1,1),(1,2),(2,1),(1,3),(3,1),(3,3),(2,3)].sorted(by: <)
    let b = [(1,1),(1,2),(2,1),(1,3),(3,1),(3,3),(2,3)].map(Pack.init).sorted(by: <)
    
    XCTAssertEqual(a.map(\.0), b.map(\.rawValue.0))
    XCTAssertEqual(a.map(\.1), b.map(\.rawValue.1))
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
