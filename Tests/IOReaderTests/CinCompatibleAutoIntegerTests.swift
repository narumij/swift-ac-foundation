import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleAutoIntegerTests: IOReaderTests {
  func testAutoDetectionAndRemainingInput() throws {
    // cin / setbase(0): binary prefixes are not recognized.
    for (input, expected, tail) in [
      ("42!", 42, "!"), ("052!", 42, "!"), ("0x2a!", 42, "!"),
      ("+0X2A!", 42, "!"), ("-052!", -42, "!"), ("-0x2a!", -42, "!"),
      ("0", 0, ""), ("00!", 0, "!"), ("09", 0, "9"), ("078", 7, "8"),
      ("0b11", 0, "b11"), ("-0B11", 0, "B11"), ("0o17", 0, "o17"),
      ("12abc", 12, "abc"), ("00x1", 0, "x1"), ("00A0", 0, "A0"),
    ] {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .auto
        XCTAssertEqual(Int.stdin, expected, input)
        for byte in tail.utf8 { XCTAssertEqual(getchar_unlocked(), Int32(byte), input) }
        XCTAssertEqual(getchar_unlocked(), EOF)
      }.exactInput(input)
    }
  }

  func testAutoMixedBasesAndModeSwitch() throws {
    try SolverRunner {
      InputConfiguration.shared.integerMode = .auto
      XCTAssertEqual(Int.stdin, 42)
      XCTAssertEqual(Int.stdin, 42)
      XCTAssertEqual(Int.stdin, 42)
      InputConfiguration.shared.integerMode = .decimal
      XCTAssertEqual(Int.stdin, 52)
      InputConfiguration.shared.integerMode = .auto
      XCTAssertEqual(Int.stdin, 42)
    }.exactInput("42 052 0x2a 052 052")
  }

  func testAutoIntegerLimits() throws {
    for (radix, prefix) in [(10, ""), (8, "0"), (16, "0x")] {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .auto
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
          InputConfiguration.shared.integerMode = .auto
          XCTAssertEqual(Int128.stdin, Int128.min)
          XCTAssertEqual(UInt128.stdin, UInt128.max)
        }.exactInput("-" + prefix + String(Int128.min.magnitude, radix: radix)
          + " " + prefix + String(UInt128.max, radix: radix))
      }
    }
  }
  func testHexPrefixRequiresADigitAndPreservesRemainingInput() throws {
    for (input, remaining) in [("0x!", "!"), ("0xx", "x"), ("0x", "")] {
      try SolverRunner {
        InputConfiguration.shared.integerMode = .auto
        XCTAssertThrowsError(try Int.read(), input) {
          XCTAssertEqual($0 as? IOReaderError, .invalidInteger, input)
        }
        for byte in remaining.utf8 {
          XCTAssertEqual(getchar_unlocked(), Int32(byte), input)
        }
        XCTAssertEqual(getchar_unlocked(), EOF, input)
      }.exactInput(input)
    }
  }

}
