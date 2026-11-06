import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleStrtodFloatingPointTests: IOReaderTests {
  func testValuesAndRemainingInput() throws {
    for (input, value, remaining) in [
      ("12abc rest", 12.0, "abc rest"), ("12x", 12.0, "x"),
      ("0x1p2!", 4.0, "!"), ("0X1.Ap+2z", 6.5, "z"),
      ("0x.8p1 ", 1.0, " "), ("0x1!", 1.0, "!"),
      ("-0.5e-2!", -0.005, "!"), ("1.2.3", 1.2, ".3"),
    ] {
      try SolverRunner {
        let savedMode = InputConfiguration.shared.floatingPointMode
        defer { InputConfiguration.shared.floatingPointMode = savedMode }
        InputConfiguration.shared.floatingPointMode = .specific
        XCTAssertEqual(try Double.read(), value, input)
        for c in remaining.utf8 { XCTAssertEqual(getchar_unlocked(), Int32(c), input) }
        XCTAssertEqual(getchar_unlocked(), EOF, input)
      }.exactInput(input)
    }
  }

  func testIncompleteSyntaxIsConsumedAndFails() throws {
    for prefix in ["+", ".", "1e", "1e+", "0x", "0x.", "0x1p-", "in", "infi", "nan("] {
      try SolverRunner {
        let savedMode = InputConfiguration.shared.floatingPointMode
        defer { InputConfiguration.shared.floatingPointMode = savedMode }
        InputConfiguration.shared.floatingPointMode = .specific
        XCTAssertThrowsError(try Double.read(), prefix) {
          XCTAssertEqual(($0 as? FloatingPointInputError)?.reason, .invalidFloatingPoint)
          XCTAssertEqual(($0 as? FloatingPointInputError)?.input, prefix)
          XCTAssertEqual(($0 as? FloatingPointInputError)?.nextByte, UInt8(ascii: "!"))
        }
        XCTAssertEqual(getchar_unlocked(), 33, prefix)
        XCTAssertEqual(getchar_unlocked(), EOF, prefix)
      }.exactInput(prefix + "!")
    }
  }

  func testInfinityAndNaN() throws {
    for input in ["inf", "INFINITY", "-inf", "+Infinity", "nan", "NAN", "nan()", "nan(payload_1)"] {
      try SolverRunner {
        let savedMode = InputConfiguration.shared.floatingPointMode
        defer { InputConfiguration.shared.floatingPointMode = savedMode }
        InputConfiguration.shared.floatingPointMode = .specific
        let value = try Double.read()
        if input.lowercased().contains("nan") { XCTAssertTrue(value.isNaN, input) }
        else {
          XCTAssertTrue(value.isInfinite, input)
          XCTAssertEqual(value.sign, input.first == "-" ? .minus : .plus, input)
        }
        XCTAssertEqual(getchar_unlocked(), 33, input)
        XCTAssertEqual(getchar_unlocked(), EOF, input)
      }.exactInput(input + "!")
    }
  }
}
