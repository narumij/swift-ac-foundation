import IOReader
import TestingUtil
import XCTest
@preconcurrency import _FastIO

final class CinCompatibleHexadecimalIntegerTests: IOReaderTests {
  func testHexadecimalSignedValuesAndRemainingInput() throws {
    for (input, expected) in [("0", 0), ("00", 0), ("2f", 47), ("0X2F", 47),
                              ("+0x3", 3), ("-0x3", -3), ("-F", -15)] {
      try SolverRunner {
        let saved = InputConfiguration.shared.integerMode
        defer { InputConfiguration.shared.integerMode = saved }
        InputConfiguration.shared.integerMode = .hexadecimal
        XCTAssertEqual(Int.stdin, expected)
        XCTAssertEqual(_getchar_unlocked(), 33)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(input + "!")
    }
  }

  func testHexadecimalUnsignedValues() throws {
    try SolverRunner {
      let saved = InputConfiguration.shared.integerMode
      defer { InputConfiguration.shared.integerMode = saved }
      InputConfiguration.shared.integerMode = .hexadecimal
      XCTAssertEqual(UInt.stdin, 47)
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, 1)
    }.exactInput("+0x2f FFFFFFFFFFFFFFFF -0xFFFFFFFFFFFFFFFF")
  }

  func testModeSwitchBetweenReads() throws {
    try SolverRunner {
      let saved = InputConfiguration.shared.integerMode
      defer { InputConfiguration.shared.integerMode = saved }
      InputConfiguration.shared.integerMode = .decimal
      XCTAssertEqual(Int.stdin, 10)
      InputConfiguration.shared.integerMode = .hexadecimal
      XCTAssertEqual(Int.stdin, 16)
      InputConfiguration.shared.integerMode = .decimal
      XCTAssertEqual(Int.stdin, 10)
    }.exactInput("10 10 10")
  }

  func testHexadecimalIntegerLimits() throws {
    try SolverRunner {
      let saved = InputConfiguration.shared.integerMode
      defer { InputConfiguration.shared.integerMode = saved }
      InputConfiguration.shared.integerMode = .hexadecimal
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int32.stdin, Int32.min)
      XCTAssertEqual(UInt32.stdin, UInt32.max)
    }.exactInput("-8000000000000000 7fffffffffffffff -80000000 ffffffff")
    if #available(macOS 15.0, *) {
      try SolverRunner {
        let saved = InputConfiguration.shared.integerMode
        defer { InputConfiguration.shared.integerMode = saved }
        InputConfiguration.shared.integerMode = .hexadecimal
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(Int128.stdin, Int128.max)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
      }.exactInput("-80000000000000000000000000000000 7fffffffffffffffffffffffffffffff ffffffffffffffffffffffffffffffff")
    }
  }
}
