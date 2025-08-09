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
        fastPrint(Int(1))
        fastPrint(Int(0))
        fastPrint(Int(-1))
        fastPrint(Int.min)
      }).run(input:""),
      """
      \(Int.max)
      1
      0
      -1
      \(Int.min)
      """)
  }
  
  func testInt2() throws {
    for i in -1_000...1_000 {
      XCTAssertEqual(
        try SolverRunner(solver: {
          fastPrint(i)
        }).run(input:""),
      """
      \(i)
      """)
    }
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

#if false
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
#endif
  
  func testScalar() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(Int(10))
        fastPrint(UInt(100))
      }).run(input:""),
      """
      10
      100
      """)
  }
  
  func testCollection() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([10,20])
        fastPrint([100,200] as [UInt])
      }).run(input:""),
      """
      10 20
      100 200
      """)
  }

  func testCombination() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(4, terminater: 0x20)
        fastPrint([0,1], terminater: 0x20)
        fastPrint([2,3])
        fastPrint(UInt(3), terminater: 0x20)
        fastPrint([100,200] as [UInt], terminater: 0x20)
        fastPrint([300] as [UInt])
      }).run(input:""),
      """
      4 0 1 2 3
      3 100 200 300
      """)
  }
  
  func testRows() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([0,1,2,3], separator: 0x0A, terminater: 0x0A)
        fastPrint([100,200,300] as [UInt], separator: 0x0A, terminater: 0x0A)
      }).run(input:""),
      """
      0
      1
      2
      3
      100
      200
      300
      """)
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
