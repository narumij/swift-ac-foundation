//
//  FastPrintTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/05/17.
//

import IOUtil
import TestingUtil
import XCTest

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
      }).run(input: ""),
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
        }).run(input: ""),
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
      }).run(input: ""),
      """
      \(UInt.max)
      \(UInt.min)
      """)
  }

  func testFastPrintableIntegerTypes() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(Int16.min)
        fastPrint(Int16.max)
        fastPrint(Int32.min)
        fastPrint(Int32.max)
        fastPrint(Int64.min)
        fastPrint(Int64.max)
        fastPrint(UInt16.min)
        fastPrint(UInt16.max)
        fastPrint(UInt32.min)
        fastPrint(UInt32.max)
        fastPrint(UInt64.min)
        fastPrint(UInt64.max)
      }).run(input: ""),
      """
      \(Int16.min)
      \(Int16.max)
      \(Int32.min)
      \(Int32.max)
      \(Int64.min)
      \(Int64.max)
      \(UInt16.min)
      \(UInt16.max)
      \(UInt32.min)
      \(UInt32.max)
      \(UInt64.min)
      \(UInt64.max)
      """)
  }

  // Int128/UInt128 are intentionally not FastPrintableInteger.
  
  func testScalar() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(Int(10))
        fastPrint(UInt(100))
      }).run(input: ""),
      """
      10
      100
      """)
  }

  func testCollection() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([10, 20])
        fastPrint([100, 200] as [UInt])
      }).run(input: ""),
      """
      10 20
      100 200
      """)
  }

  func testCombination() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(4, terminator: 0x20)
        fastPrint([0, 1], terminator: 0x20)
        fastPrint([2, 3])
        fastPrint(UInt(3), terminator: 0x20)
        fastPrint([100, 200] as [UInt], terminator: 0x20)
        fastPrint([300] as [UInt])
      }).run(input: ""),
      """
      4 0 1 2 3
      3 100 200 300
      """)
  }

  func testRows() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([0, 1, 2, 3], separator: 0x0A, terminator: 0x0A)
        fastPrint([100, 200, 300] as [UInt], separator: 0x0A, terminator: 0x0A)
      }).run(input: ""),
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

  func testInt8() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let a: [Int8] = "Hello".cString(using: .ascii)!
        fastPrint(asciiValues: a)
      }).run(input: ""),
      """
      Hello
      """)
  }

  func testUInt8() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let a: [UInt8] = "Hello".compactMap(\.asciiValue)
        fastPrint(asciiValues: a)
      }).run(input: ""),
      """
      Hello
      """)
  }

  func testCharacter() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let a: [Character] = Array("Hello")
        fastPrint(a)
      }).run(input: ""),
      """
      Hello
      """)
  }

  func testPerformanceExample() throws {

    let a: [Int] = .init((Int.max - 30_000)..<Int.max)

    self.measure {
      StdoutSilencer.run {
        fastPrint(a)
      }
    }
  }
}
