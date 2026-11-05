import Foundation
import IOReader
import TestingUtil
import XCTest
@preconcurrency import _FastIO

final class CinCompatibleFloatingPointTests: IOReaderTests {
  // Test as Specの原型:
  // Maintanance/Studio/reviews/stdin-cin-20261105/CIN_READING_GUIDE.md「浮動小数の読取り」。
  // ASCII / classic locale / skipws有効。失敗はSwift側ではread()の例外として確認。
  // 異常入力の消費範囲は保存済みのlibc++観測に基づく。全C++実装共通とはしない。

  private func assertRemaining(_ text: String, file: StaticString = #filePath, line: UInt = #line) {
    for byte in text.utf8 {
      XCTAssertEqual(_getchar_unlocked(), Int32(byte), file: file, line: line)
    }
    XCTAssertEqual(_getchar_unlocked(), EOF, file: file, line: line)
  }

  func testDecimalPointAndExponent() throws {
    for (input, expected) in [
      ("1.25", 1.25), (".5", 0.5), ("1.", 1.0),
      ("1e3", 1000.0), ("-1.25", -1.25), ("+1.25", 1.25),
      ("1E+3", 1000.0), ("1e-3", 0.001),
    ] {
      try SolverRunner {
        XCTAssertEqual(try Double.read(), expected, input)
        self.assertRemaining("")
      }
      .exactInput(input)
    }
  }

  func testLeadingWhitespaceAndPreservedSeparator() throws {
    for whitespace in [" ", "\t", "\n", "\r", "\u{0B}", "\u{0C}"] {
      try SolverRunner {
        XCTAssertEqual(try Double.read(), 1.25)
        self.assertRemaining(whitespace + "rest")
      }
      .exactInput(whitespace + "1.25" + whitespace + "rest")
    }
  }

  func testStopsAtSecondDecimalPointOrNonCandidateCharacter() throws {
    for (input, expected, remaining) in [("1.2.3", 1.2, ".3"), ("12z", 12.0, "z")] {
      try SolverRunner {
        XCTAssertEqual(try Double.read(), expected, input)
        self.assertRemaining(remaining)
      }
      .exactInput(input)
    }
  }

  func testIncompleteExponentFailsAfterConsumption() throws {
    for input in ["1e", "1e+"] {
      try SolverRunner {
        XCTAssertThrowsError(try Double.read(), input)
        self.assertRemaining("")
      }
      .exactInput(input)
    }
  }

  #if LLVM_FLOAT_INPUT
  func testLibcxxInvalidCandidateConsumption() throws {
    for input in ["12x", "12abc"] {
      try SolverRunner {
        XCTAssertThrowsError(try Double.read(), input)
        self.assertRemaining("")
      }
      .exactInput(input)
    }
  }

  func testLibcxxSpecialNamesFailWithoutConsumption() throws {
    for input in ["nan", "inf"] {
      try SolverRunner {
        XCTAssertThrowsError(try Double.read(), input)
        self.assertRemaining(input)
      }
      .exactInput(input)
    }
  }

  #endif

  func testHexadecimalFloat() throws {
    try SolverRunner {
      XCTAssertEqual(try Double.read(), 4)
      self.assertRemaining("")
    }
    .exactInput("0x1p2")
  }

  func testEOFBeforeValue() throws {
    try SolverRunner {
      XCTAssertThrowsError(try Double.read()) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
      }
      self.assertRemaining("")
    }
    .emptyInput()
  }

  func testEOFAfterWhitespace() throws {
    try SolverRunner {
      XCTAssertThrowsError(try Double.read()) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
      }
      self.assertRemaining("")
    }
    .exactInput(" \t\n")
  }
}
