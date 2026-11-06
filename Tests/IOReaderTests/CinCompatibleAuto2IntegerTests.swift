import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleAuto2IntegerTests: IOReaderTests {
  func testAuto2DetectionAndRemainingInput() throws {
    // Extension of cin-style Auto: also recognize 0b/0B.
    for (input, expected, tail) in [
      ("42!", 42, "!"), ("052!", 42, "!"), ("0x2a!", 42, "!"),
      ("+0X2A!", 42, "!"), ("-052!", -42, "!"), ("-0x2a!", -42, "!"),
      ("0", 0, ""), ("00!", 0, "!"), ("09", 0, "9"), ("078", 7, "8"),
      ("0b11", 3, ""), ("-0B11", -3, ""), ("+0b101!", 5, "!"), ("0b102", 2, "2"), ("0B0", 0, ""), ("0o17", 0, "o17"),
      ("12abc", 12, "abc"), ("00x1", 0, "x1"),
    ] {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .auto2
        XCTAssertEqual(Int.stdin, expected, input)
        for byte in tail.utf8 { XCTAssertEqual(getchar_unlocked(), Int32(byte), input) }
        XCTAssertEqual(getchar_unlocked(), EOF)
      }.exactInput(input)
    }
  }

  func testAuto2MixedBasesAndModeSwitch() throws {
    try SolverRunner {
      InputConfiguration.shared.integerMode = .auto2
      XCTAssertEqual(Int.stdin, 42)
      XCTAssertEqual(Int.stdin, 42)
      XCTAssertEqual(Int.stdin, 42)
      InputConfiguration.shared.integerMode = .decimal
      XCTAssertEqual(Int.stdin, 52)
      InputConfiguration.shared.integerMode = .auto2
      XCTAssertEqual(Int.stdin, 42)
    }.exactInput("42 052 0x2a 052 052")
  }

  func testAuto2IntegerLimits() throws {
    for (radix, prefix) in [(2, "0b"), (10, ""), (8, "0"), (16, "0x")] {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .auto2
        XCTAssertEqual(Int.stdin, Int.min)
        XCTAssertEqual(Int.stdin, Int.max)
        XCTAssertEqual(UInt.stdin, UInt.max)
        XCTAssertEqual(UInt.stdin, 1)
      }.exactInput("-" + prefix + String(Int.min.magnitude, radix: radix)
        + " " + prefix + String(Int.max, radix: radix)
        + " " + prefix + String(UInt.max, radix: radix)
        + " -" + prefix + String(UInt.max, radix: radix))
      if #available(macOS 15.0, *) {
        try SolverRunner {
          InputConfiguration.shared.integerMode = .auto2
          XCTAssertEqual(Int128.stdin, Int128.min)
          XCTAssertEqual(UInt128.stdin, UInt128.max)
        }.exactInput("-" + prefix + String(Int128.min.magnitude, radix: radix)
          + " " + prefix + String(UInt128.max, radix: radix))
      }
    }
  }
  func testAuto2AndAutoTreatBinaryPrefixDifferently() throws {
    try SolverRunner {
      InputConfiguration.shared.integerMode = .auto
      XCTAssertEqual(Int.stdin, 0)
      XCTAssertEqual(Character.stdin, "b")
      XCTAssertEqual(Int.stdin, 11)
      InputConfiguration.shared.integerMode = .auto2
      XCTAssertEqual(Int.stdin, 3)
      XCTAssertEqual(getchar_unlocked(), EOF)
    }.exactInput("0b11 0b11")
  }

}
