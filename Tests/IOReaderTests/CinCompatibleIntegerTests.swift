import Foundation
import IOReader
import TestingUtil
import XCTest
import _FastIO

final class CinCompatibleIntegerTests: XCTestCase {
  // Test as Spec: CIN_READING_GUIDE.md「前提」「整数の読取り」。
  // 資料: Maintanance/Studio/reviews/stdin-cin-20261105/CIN_READING_GUIDE.md
  // ASCII / classic locale / skipws有効 / 十進。
  // 現在対応する範囲：十進数字、負号、SP・HT・LF・CR、型の範囲内。
  // TODO: 正符号、VT・FF、数字以外での停止、符号なしの負号は未対応。
  // これらの現在の挙動を仕様として固定するテストは追加しない。

  func testDecimalValuesAndLeadingZeros() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, 0)
      XCTAssertEqual(Int.stdin, 12)
      XCTAssertEqual(Int.stdin, -12)
      XCTAssertEqual(Int.stdin, 12)
      XCTAssertEqual(Int.stdin, 10) // 先頭0でも十進。
      XCTAssertEqual(Int.stdin, 0) // 負のゼロ。
      XCTAssertEqual(_getchar_unlocked(), 10)
      XCTAssertEqual(_getchar_unlocked(), EOF)
    }).inputOnly("0 12 -12 0012 010 -0")
  }

  func testLeadingWhitespaceIsSkippedAndTrailingSeparatorRemains() throws {
    for separator in [" ", "\t", "\n", "\r"] {
      try SolverRunner(solver: {
        XCTAssertEqual(Int.stdin, -12)
        XCTAssertEqual(_getchar_unlocked(), Int32(separator.utf8.first!))
        XCTAssertEqual(_getchar_unlocked(), 120) // 後続のxも残る。
        XCTAssertEqual(_getchar_unlocked(), 10)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }).inputOnly("\(separator)\(separator)-12\(separator)x")
    }
  }

  func testRepeatedReadsSkipPreservedWhitespaceAcrossLines() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, 12)
      XCTAssertEqual(try Int.read(), 34)
      XCTAssertEqual(Int.stdin, -56)
      XCTAssertEqual(UInt.stdin, 78)
      XCTAssertEqual(_getchar_unlocked(), 10)
      XCTAssertEqual(_getchar_unlocked(), EOF)
    }).inputOnly("12\n\t34  -56\r\n78")
  }

  func testSignedIntegerLimits() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(CInt.stdin, CInt.min)
      XCTAssertEqual(CInt.stdin, CInt.max)
      XCTAssertEqual(CLongLong.stdin, CLongLong.min)
      XCTAssertEqual(CLongLong.stdin, CLongLong.max)
      XCTAssertEqual(_getchar_unlocked(), 10)
      XCTAssertEqual(_getchar_unlocked(), EOF)
    }).inputOnly("\(Int.min) \(Int.max) \(CInt.min) \(CInt.max) \(CLongLong.min) \(CLongLong.max)")
  }

  func testUnsignedIntegerLimits() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(UInt.stdin, 0)
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(CUnsignedInt.stdin, CUnsignedInt.max)
      XCTAssertEqual(CUnsignedLongLong.stdin, CUnsignedLongLong.max)
      XCTAssertEqual(_getchar_unlocked(), 10)
      XCTAssertEqual(_getchar_unlocked(), EOF)
    }).inputOnly("0 \(UInt.max) \(CUnsignedInt.max) \(CUnsignedLongLong.max)")
  }

  func test128BitIntegerLimits() throws {
    if #available(macOS 15.0, *) {
      try SolverRunner(solver: {
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(Int128.stdin, Int128.max)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
        XCTAssertEqual(_getchar_unlocked(), 10)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }).inputOnly("\(Int128.min) \(Int128.max) \(UInt128.max)")
    }
  }
}
