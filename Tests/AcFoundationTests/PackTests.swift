//
//  PackTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/06/18.
//

import XCTest
import Pack

final class PackTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testExample() throws {
      let p: Pack<Int,Int,Int> = .init(1,2,3)
      XCTAssertEqual(p.tuple.0, 1)
      XCTAssertEqual(p.tuple.1, 2)
      XCTAssertEqual(p.tuple.2, 3)
      let a: [Pack<Int>: Int] = [.init(1): 1]
      let b: [Pack<Int,Int>: Int] = [.init(1, 1): 1]
      let c: [Pack<Int,Int,Int>: Int] = [.init(1, 1, 1): 1]
      let d: [Pack<Int,Int,Int,Int>: Int] = [.init(1, 1, 1, 1): 1]
      XCTAssertEqual(a[.init(1)], 1)
      XCTAssertEqual(b[.init(1, 1)], 1)
      XCTAssertEqual(c[.init(1, 1, 1)], 1)
      XCTAssertEqual(d[.init(1, 1, 1, 1)], 1)
      let e: [Pack<Int, UInt, String, Int>: Int] = [.init(1, 1, "", 1): 1]
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
