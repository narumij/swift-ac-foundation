//
//  IndexHelperTests 2.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/08/11.
//

import Miscellaneous
import XCTest
import Pack

final class IndexHelperTests_2: XCTestCase {

  var array: [Int] = []
  var helper: IndexHelper2D!
  var transposed: TransposedIndexHelper2D!

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    array = [1, 2, 3, 4, 5, 6, 7, 8]
    helper = .init(4, 3)
    transposed = helper.transposed
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    XCTAssertEqual(1, array[helper[0, 0]])
    XCTAssertEqual(2, array[helper[1, 0]])
    XCTAssertEqual(3, array[helper[2, 0]])
    XCTAssertEqual(4, array[helper[3, 0]])
    XCTAssertEqual(5, array[helper[0, 1]])
    XCTAssertEqual(6, array[helper[1, 1]])
    XCTAssertEqual(7, array[helper[2, 1]])
    XCTAssertEqual(8, array[helper[3, 1]])
    XCTAssertEqual(1, array[transposed[0, 0]])
    XCTAssertEqual(2, array[transposed[0, 1]])
    XCTAssertEqual(3, array[transposed[0, 2]])
    XCTAssertEqual(4, array[transposed[0, 3]])
    XCTAssertEqual(5, array[transposed[1, 0]])
    XCTAssertEqual(6, array[transposed[1, 1]])
    XCTAssertEqual(7, array[transposed[1, 2]])
    XCTAssertEqual(8, array[transposed[1, 3]])
    XCTAssertEqual(0, transposed[0, 0])
    XCTAssertEqual(1, transposed[0, 1])
    XCTAssertEqual(2, transposed[0, 2])
    XCTAssertEqual(3, transposed[0, 3])
    XCTAssertEqual(4, transposed[1, 0])
    XCTAssertEqual(5, transposed[1, 1])
    XCTAssertEqual(6, transposed[1, 2])
    XCTAssertEqual(7, transposed[1, 3])
    XCTAssertEqual(Pack(0, 0), Pack(rawValue: transposed.position(at: 0)))
    XCTAssertEqual(Pack(0, 1), Pack(rawValue: transposed.position(at: 1)))
    XCTAssertEqual(Pack(0, 2), Pack(rawValue: transposed.position(at: 2)))
    XCTAssertEqual(Pack(0, 3), Pack(rawValue: transposed.position(at: 3)))
    XCTAssertEqual(Pack(1, 0), Pack(rawValue: transposed.position(at: 4)))
    XCTAssertEqual(Pack(1, 1), Pack(rawValue: transposed.position(at: 5)))
    XCTAssertEqual(Pack(1, 2), Pack(rawValue: transposed.position(at: 6)))
    XCTAssertEqual(Pack(1, 3), Pack(rawValue: transposed.position(at: 7)))
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
