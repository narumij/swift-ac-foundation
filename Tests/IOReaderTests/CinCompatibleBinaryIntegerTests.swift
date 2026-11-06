import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleBinaryIntegerTests: IOReaderTests {
  // Binary is an extension; cin has no binary input manipulator.
  func testBinaryInput() throws {
    for (input, expected) in [("0", 0), ("101", 5), ("+0b11", 3), ("-0B11", -3)] {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .binary
        XCTAssertEqual(Int.stdin, expected)
        XCTAssertEqual(getchar_unlocked(), 33)
        XCTAssertEqual(getchar_unlocked(), EOF)
      }.exactInput(input + "!")
    }
    try SolverRunner {
      InputConfiguration.shared.integerMode = .binary
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, 1)
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int.stdin, 1)
      XCTAssertEqual(getchar_unlocked(), 50)
    }.exactInput(String(UInt.max, radix: 2) + " -" + String(UInt.max, radix: 2)
      + " " + String(Int.min, radix: 2) + " " + String(Int.max, radix: 2) + " 12")
    if #available(macOS 15.0, *) {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .binary
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
      }.exactInput(String(Int128.min, radix: 2) + " " + String(UInt128.max, radix: 2))
    }
  }
}
