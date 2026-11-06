import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleOctalIntegerTests: IOReaderTests {
  // Explicit octal input; a leading zero is optional.
  func testOctalInput() throws {
    for (input, expected) in [("0", 0), ("017", 15), ("+17", 15), ("-017", -15)] {
      try SolverRunner {
        let saved = InputConfiguration.shared.integerMode
        defer { InputConfiguration.shared.integerMode = saved }
        InputConfiguration.shared.integerMode = .octal
        XCTAssertEqual(Int.stdin, expected)
        XCTAssertEqual(getchar_unlocked(), 33)
        XCTAssertEqual(getchar_unlocked(), EOF)
      }.exactInput(input + "!")
    }
    try SolverRunner {
      let saved = InputConfiguration.shared.integerMode
      defer { InputConfiguration.shared.integerMode = saved }
      InputConfiguration.shared.integerMode = .octal
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, 1)
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int.stdin, 1)
      XCTAssertEqual(getchar_unlocked(), 56)
    }.exactInput(String(UInt.max, radix: 8) + " -" + String(UInt.max, radix: 8)
      + " " + String(Int.min, radix: 8) + " " + String(Int.max, radix: 8) + " 18")
    if #available(macOS 15.0, *) {
      try SolverRunner {
        let saved = InputConfiguration.shared.integerMode
        defer { InputConfiguration.shared.integerMode = saved }
        InputConfiguration.shared.integerMode = .octal
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
      }.exactInput(String(Int128.min, radix: 8) + " " + String(UInt128.max, radix: 8))
    }
  }
}
