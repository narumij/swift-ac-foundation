import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleStringTests: IOReaderTests {
  // Test as Spec: CIN_READING_GUIDE.md「前提」「単語と行の読取り」。
  // Specifications/CIN_READING_GUIDE.md
  // ASCII / classic locale / skipws有効 / width=0。NULは対象外。

  func testWordAndRemainingInput() throws {
    for (input, expected, remaining) in [
      (" abc def", "abc", " def"),
      ("abc\ndef", "abc", "\ndef"),
      ("#.........##.............# next", "#.........##.............#", " next"),
      ("12abc +1.2", "12abc", " +1.2"),
    ] {
      try SolverRunner {
        XCTAssertEqual(try String.read(), expected, input)
        for byte in remaining.utf8 {
          XCTAssertEqual(getchar_unlocked(), Int32(byte), input)
        }
        XCTAssertEqual(getchar_unlocked(), EOF, input)
      }.exactInput(input)
    }
  }

  func testAllSixWhitespaceCharactersAreSkippedBeforeWordAndPreservedAfterIt() throws {
    for whitespace in [" ", "\t", "\n", "\r", "\u{0B}", "\u{0C}"] {
      try SolverRunner {
        XCTAssertEqual(String.stdin, "abc")
        XCTAssertEqual(getchar_unlocked(), Int32(whitespace.utf8.first!))
        XCTAssertEqual(getchar_unlocked(), Int32(whitespace.utf8.first!))
        XCTAssertEqual(try String.read(), "def")
        XCTAssertEqual(getchar_unlocked(), EOF)
      }.exactInput(whitespace + whitespace + "abc" + whitespace + whitespace + "def")
    }
  }

  func testWordAtEOFSucceedsAndNextReadFails() throws {
    try SolverRunner {
      XCTAssertEqual(try String.read(), "abc")
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
      }
      XCTAssertEqual(getchar_unlocked(), EOF)
    }.exactInput("abc")
  }

  func testEmptyInputFails() throws {
    try SolverRunner {
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
      }
      XCTAssertEqual(getchar_unlocked(), EOF)
    }.emptyInput()
  }

  func testWhitespaceOnlyInputFailsAfterConsumption() throws {
    try SolverRunner {
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
      }
      XCTAssertEqual(getchar_unlocked(), EOF)
    }.exactInput(" \t\n\r\u{0B}\u{0C}")
  }

  func testRepeatedWordsAndCharacterReading() throws {
    try SolverRunner {
      XCTAssertEqual(try String.read(), "abc")
      XCTAssertEqual(Character.stdin, "d")
      XCTAssertEqual(try String.read(), "ef")
      XCTAssertEqual(try String.read(), "ghi")
      XCTAssertEqual(getchar_unlocked(), EOF)
    }.exactInput("abc def\nghi")
  }
}
