//
//  FastPrintTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/05/17.
//

import IOUtil
import TestingUtil
import XCTest
import _FastIO

final class FastPrintTests: XCTestCase {

  private static let fastPrintPerformanceValues: [Int64] = {
    let count = 30_000
    let max = UInt64(Int.max)
    let step = max / UInt64(count - 1)

    return (0..<count).map { index in
      if index == count - 1 {
        return Int64.max
      }
      return Int64(1 + UInt64(index) * step)
    }
  }()

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

  func testFastPrintFourDigitBoundaries() throws {
    let values = [-10_001, -10_000, -9_999, -1_001, -1_000, -999, 999, 1_000, 1_001, 9_999, 10_000, 10_001]

    XCTAssertEqual(
      try SolverRunner(solver: {
        values.forEach { fastPrint($0) }
      }).run(input: ""),
      values.map(String.init).joined(separator: "\n")
    )
  }

  func testFastPrintDigitWidthImplementations() throws {
    let signedValues: [Int64] = [
      Int64.min, -10_001, -10_000, -9_999, -101, -100, -99, -10, -9, 0,
      9, 10, 99, 100, 101, 9_999, 10_000, 10_001, Int64.max
    ]
    let unsignedValues: [UInt64] = [
      UInt64.min, 9, 10, 99, 100, 101, 9_999, 10_000, 10_001, UInt64.max
    ]
    let expected = (signedValues.map(String.init) + unsignedValues.map(String.init)).joined(separator: "\n")

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___print_int_one($0); print() }
        unsignedValues.forEach { ___print_uint_one($0); print() }
      }).run(input: ""),
      expected
    )

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___print_int_two($0); print() }
        unsignedValues.forEach { ___print_uint_two($0); print() }
      }).run(input: ""),
      expected
    )

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___print_int_four($0); print() }
        unsignedValues.forEach { ___print_uint_four($0); print() }
      }).run(input: ""),
      expected
    )
  }

  func testFastPrintTwoDigitTableRange() throws {
    let signedValues = Array(Int64(-99)...Int64(-1)) + Array(Int64(1)...Int64(99))
    let unsignedValues = Array(UInt64(1)...UInt64(99))
    let expected = (signedValues.map(String.init) + unsignedValues.map(String.init)).joined(separator: "\n")

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___print_int_two($0); print() }
        unsignedValues.forEach { ___print_uint_two($0); print() }
      }).run(input: ""),
      expected
    )
  }

  func testFastPrintFourDigitTableRange() throws {
    let signedValues = Array(Int64(-9_999)...Int64(-1)) + Array(Int64(1)...Int64(9_999))
    let unsignedValues = Array(UInt64(1)...UInt64(9_999))
    let expected = (signedValues.map(String.init) + unsignedValues.map(String.init)).joined(separator: "\n")

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___print_int_four($0); print() }
        unsignedValues.forEach { ___print_uint_four($0); print() }
      }).run(input: ""),
      expected
    )
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

  func testNilTerminator() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint(Int(12), terminator: nil)
        fastPrint(UInt(34), terminator: nil)
        fastPrint(asciiValues: Array("ab".utf8), terminator: nil)
        fastPrint(Array("cd"), terminator: nil)
      }).run(input: ""),
      "1234abcd")
  }

  func testEmptyCollectionsProduceNoOutput() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([] as [Int])
        fastPrint([] as [UInt])
      }).run(input: ""),
      "")
  }

  func testCollectionTransform() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([1, 2, 3], { Int32($0 * -2) })
        fastPrint([1, 2, 3], { UInt32($0 * 2) })
      }).run(input: ""),
      """
      -2 -4 -6
      2 4 6
      """)
  }

  func testCustomSeparatorsAndTerminatorsForTransform() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        fastPrint([1, 2, 3], { Int64($0) }, separator: 0x2C, terminator: 0x3B)
        fastPrint([1, 2, 3], { UInt64($0) }, separator: 0x2D, terminator: 0x21)
      }).run(input: ""),
      "1,2,3;1-2-3!")
  }

  func testPerformanceExample() throws {

    let a: [Int] = .init((Int.max - 30_000)..<Int.max)

    self.measure {
      StdoutSilencer.run {
        fastPrint(a)
      }
    }
  }

  func testPerformanceFastPrintOneDigitImplementation() throws {
    let values = Self.fastPrintPerformanceValues

    self.measure {
      StdoutSilencer.run {
        for value in values {
          ___print_int_one(value)
          putchar_unlocked(0x0A)
        }
      }
    }
  }

  func testPerformanceFastPrintTwoDigitImplementation() throws {
    let values = Self.fastPrintPerformanceValues

    self.measure {
      StdoutSilencer.run {
        for value in values {
          ___printIntTwo(value)
          putchar_unlocked(0x0A)
        }
      }
    }
  }

  func testPerformanceFastPrintFourDigitImplementation() throws {
    let values = Self.fastPrintPerformanceValues

    self.measure {
      StdoutSilencer.run {
        for value in values {
          ___print_int_four(value)
          putchar_unlocked(0x0A)
        }
      }
    }
  }
  
  func testPerformanceFastPrintEightDigitImplementation() throws {
    let values = Self.fastPrintPerformanceValues

    self.measure {
      StdoutSilencer.run {
        for value in values {
          ___print_int_eight(value)
          putchar_unlocked(0x0A)
        }
      }
    }
  }
  
  func testPerformanceFastPrintDigitImplementation() throws {
    let values = Self.fastPrintPerformanceValues

    self.measure {
      StdoutSilencer.run {
        for value in values {
          ___print_int(value)
          putchar_unlocked(0x0A)
        }
      }
    }
  }

  func testPerformanceNewFastPrintFourDigitImplementation() throws {
    let values = Self.fastPrintPerformanceValues

    self.measure {
      StdoutSilencer.run {
        for value in values {
          _fastPrint(value)
          putchar_unlocked(0x0A)
        }
      }
    }
  }
}
