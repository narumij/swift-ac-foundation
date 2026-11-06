import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleCharacterTests: IOReaderTests {

  // Test as Spec: CIN_READING_GUIDE.md「前提」「文字の読取り」。
  // 資料: Specifications/CIN_READING_GUIDE.md
  // ASCII / classic locale / skipws有効。文字を1つ読み、後続を残す。
  func testCharacterConsumesOneCharacterAndLeavesTheRest() throws {
    for (input, expected, remaining) in [
      ("ab", Character("a"), "b"),
      (" a b", Character("a"), " b"),
      ("1 2", Character("1"), " 2"),
    ] {
      try SolverRunner(solver: {
        XCTAssertEqual(Character.stdin, expected)
        for byte in (remaining + "\n").utf8 {
          XCTAssertEqual(getchar_unlocked(), Int32(byte))
        }
        XCTAssertEqual(getchar_unlocked(), EOF)
      }).inputOnly(input)
    }
  }

  func testUInt8ReadsACharacterRatherThanANumber() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(UInt8.stdin, 49)  // ASCII '1'、数値1ではない。
      XCTAssertEqual(UInt8.stdin, 50)  // ASCII '2'
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("12")
  }

  func testAllSixASCIIWhitespaceCharactersAreSkippedOnlyBeforeTheCharacter() throws {
    for whitespace in [" ", "\t", "\n", "\u{0B}", "\u{0C}", "\r"] {
      try SolverRunner(solver: {
        XCTAssertEqual(Character.stdin, "a")
        XCTAssertEqual(getchar_unlocked(), Int32(whitespace.utf8.first!))
        XCTAssertEqual(UInt8.stdin, 98)
        XCTAssertEqual(getchar_unlocked(), Int32(whitespace.utf8.first!))
        XCTAssertEqual(getchar_unlocked(), 10)
      }).inputOnly("\(whitespace)a\(whitespace)\(whitespace)b\(whitespace)\n")
    }
  }

  func testSingleAndFixedWidthReadersPreserveFollowingCharacters() throws {
    try SolverRunner(solver: {
      // stdin/readも指定した幅だけ読む。cinとの交互利用でも文字を落とさない。
      XCTAssertEqual(Character.stdin, "a")
      XCTAssertEqual(Character.stdin, "b")
      XCTAssertEqual(UInt8.stdin, 99)
      XCTAssertEqual(UInt8.stdin, 100)
      XCTAssertEqual(try String.read(columns: 2), "ef")
      XCTAssertEqual(Character.stdin, "g")
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("abcdefg\n")
  }
}
