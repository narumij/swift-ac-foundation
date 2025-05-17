//
//  FastPrintTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/05/17.
//

import XCTest
import IOUtil

final class FastPrintTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testInt() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(Int.max)
        fastPrint(Int(0))
        fastPrint(Int.min)
      }).run(input:""),
      """
      \(Int.max)
      0
      \(Int.min)
      """)
  }
  
  func testUInt() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(UInt.max)
        fastPrint(UInt.min)
      }).run(input:""),
      """
      \(UInt.max)
      \(UInt.min)
      """)
  }

  func testInt128() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(Int128.max)
        fastPrint(Int128(0))
        fastPrint(Int128.min)
      }).run(input:""),
      """
      \(Int128.max)
      0
      \(Int128.min)
      """)
  }
  
  func testUInt128() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(UInt128.max)
        fastPrint(UInt128.min)
      }).run(input:""),
      """
      \(UInt128.max)
      \(UInt128.min)
      """)
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }

  func testPerformanceExample() throws {
    
    let a: [Int] = .init((Int.max - 30_000) ..< Int.max)
    
    self.measure {
      StdoutSilencer.run {
        fastPrint(a)
      }
    }
  }
}
