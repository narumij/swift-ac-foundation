import Foundation
import IOReader
import TestingUtil
import XCTest

final class ReadCinTests: XCTestCase {
  func testConsecutiveCharacters() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Character.cin, "a")
      XCTAssertEqual(try Character.readCin(), "b")
      XCTAssertEqual(UInt8.cin, 99)
      XCTAssertEqual(try UInt8.readCin(), 100)
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("abcd\n")
  }

  func testLeadingWhitespaceIsSkippedAndTrailingWhitespaceRemains() throws {
    for whitespace in [" ", "\t", "\n", "\u{0B}", "\u{0C}", "\r"] {
      try SolverRunner(solver: {
        XCTAssertEqual(try Character.readCin(), "a")
        XCTAssertEqual(getchar_unlocked(), Int32(whitespace.utf8.first!))
        XCTAssertEqual(try UInt8.readCin(), 98)
        XCTAssertEqual(getchar_unlocked(), Int32(whitespace.utf8.first!))
      }).inputOnly("\(whitespace)a\(whitespace)\(whitespace)b\(whitespace)\n")
    }
  }

  func testFollowingLineStartsAtTheUnconsumedNewline() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Character.cin, "a")
      XCTAssertEqual(String.stdin(read: .line), "")
      XCTAssertEqual(UInt8.cin, 98)
      XCTAssertEqual(String.stdin(read: .line), " c")
      XCTAssertEqual(String.stdin(read: .line), "tail")
    }).inputOnly("a\nb c\ntail\n")
  }

  func testEOFThrows() throws {
    for input in ["", " \t\n\u{0B}\u{0C}\r"] {
      try SolverRunner(solver: {
        XCTAssertThrowsError(try Character.readCin()) {
          XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
        }
        XCTAssertThrowsError(try UInt8.readCin()) {
          XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
        }
      }).inputOnly(input)
    }
  }

  #if false
  func testExistingSingleAndFixedWidthReadersKeepTheirConsumption() throws {
    try SolverRunner(solver: {
      // 既存入口は幅分の直後の1バイトも消費する。別名のcinとは併存させる。
      XCTAssertEqual(Character.stdin, "a")
      XCTAssertEqual(Character.cin, "c")
      XCTAssertEqual(UInt8.stdin, 100)
      XCTAssertEqual(UInt8.cin, 102)
      XCTAssertEqual(try String.read(columns: 2), "gh")
      XCTAssertEqual(Character.cin, "j")
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("abcdefghij\n")
  }
  #else
  func testSingleAndFixedWidthReadersPreserveFollowingCharacters() throws {
    try SolverRunner(solver: {
      // stdin/readも指定した幅だけ読む。cinとの交互利用でも文字を落とさない。
      XCTAssertEqual(Character.stdin, "a")
      XCTAssertEqual(Character.cin, "b")
      XCTAssertEqual(UInt8.stdin, 99)
      XCTAssertEqual(UInt8.cin, 100)
      XCTAssertEqual(try String.read(columns: 2), "ef")
      XCTAssertEqual(Character.cin, "g")
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("abcdefg\n")
  }
  #endif
}
