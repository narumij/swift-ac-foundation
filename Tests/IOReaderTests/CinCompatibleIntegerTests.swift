import IOReader
import TestingUtil
import XCTest
@preconcurrency import _FastIO

final class CinCompatibleIntegerTests: IOReaderTests {
  func testHexadecimalSignedValuesAndRemainingInput() throws {
    for (input, expected) in [("0", 0), ("00", 0), ("2f", 47), ("0X2F", 47),
                              ("+0x3", 3), ("-0x3", -3), ("-F", -15)] {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerHexadecimal
        XCTAssertEqual(Int.stdin, expected)
        XCTAssertEqual(_getchar_unlocked(), 33)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(input + "!")
    }
  }

  func testHexadecimalUnsignedValues() throws {
    try SolverRunner {
      let saved = _fastio_integer_mode
      defer { _fastio_integer_mode = saved }
      _fastio_integer_mode = FastIOIntegerHexadecimal
      XCTAssertEqual(UInt.stdin, 47)
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, 1)
    }.exactInput("+0x2f FFFFFFFFFFFFFFFF -0xFFFFFFFFFFFFFFFF")
  }

  func testModeSwitchBetweenReads() throws {
    try SolverRunner {
      let saved = _fastio_integer_mode
      defer { _fastio_integer_mode = saved }
      _fastio_integer_mode = FastIOIntegerDecimal
      XCTAssertEqual(Int.stdin, 10)
      _fastio_integer_mode = FastIOIntegerHexadecimal
      XCTAssertEqual(Int.stdin, 16)
      _fastio_integer_mode = FastIOIntegerDecimal
      XCTAssertEqual(Int.stdin, 10)
    }.exactInput("10 10 10")
  }

  func testHexadecimalIntegerLimits() throws {
    try SolverRunner {
      let saved = _fastio_integer_mode
      defer { _fastio_integer_mode = saved }
      _fastio_integer_mode = FastIOIntegerHexadecimal
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int32.stdin, Int32.min)
      XCTAssertEqual(UInt32.stdin, UInt32.max)
    }.exactInput("-8000000000000000 7fffffffffffffff -80000000 ffffffff")
    if #available(macOS 15.0, *) {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerHexadecimal
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(Int128.stdin, Int128.max)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
      }.exactInput("-80000000000000000000000000000000 7fffffffffffffffffffffffffffffff ffffffffffffffffffffffffffffffff")
    }
  }
  // Binary is an extension; cin has no binary input manipulator.
  func testBinaryInput() throws {
    for (input, expected) in [("0", 0), ("101", 5), ("+0b11", 3), ("-0B11", -3)] {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerBinary
        XCTAssertEqual(Int.stdin, expected)
        XCTAssertEqual(_getchar_unlocked(), 33)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(input + "!")
    }
    try SolverRunner {
      let saved = _fastio_integer_mode
      defer { _fastio_integer_mode = saved }
      _fastio_integer_mode = FastIOIntegerBinary
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, 1)
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int.stdin, 1)
      XCTAssertEqual(_getchar_unlocked(), 50)
    }.exactInput(String(UInt.max, radix: 2) + " -" + String(UInt.max, radix: 2)
      + " " + String(Int.min, radix: 2) + " " + String(Int.max, radix: 2) + " 12")
    if #available(macOS 15.0, *) {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerBinary
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
      }.exactInput(String(Int128.min, radix: 2) + " " + String(UInt128.max, radix: 2))
    }
  }

  // Explicit octal input; a leading zero is optional.
  func testOctalInput() throws {
    for (input, expected) in [("0", 0), ("017", 15), ("+17", 15), ("-017", -15)] {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerOctal
        XCTAssertEqual(Int.stdin, expected)
        XCTAssertEqual(_getchar_unlocked(), 33)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(input + "!")
    }
    try SolverRunner {
      let saved = _fastio_integer_mode
      defer { _fastio_integer_mode = saved }
      _fastio_integer_mode = FastIOIntegerOctal
      XCTAssertEqual(UInt.stdin, UInt.max)
      XCTAssertEqual(UInt.stdin, 1)
      XCTAssertEqual(Int.stdin, Int.min)
      XCTAssertEqual(Int.stdin, Int.max)
      XCTAssertEqual(Int.stdin, 1)
      XCTAssertEqual(_getchar_unlocked(), 56)
    }.exactInput(String(UInt.max, radix: 8) + " -" + String(UInt.max, radix: 8)
      + " " + String(Int.min, radix: 8) + " " + String(Int.max, radix: 8) + " 18")
    if #available(macOS 15.0, *) {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerOctal
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
      }.exactInput(String(Int128.min, radix: 8) + " " + String(UInt128.max, radix: 8))
    }
  }

  func testAutoDetectionAndRemainingInput() throws {
    // cin / setbase(0): binary prefixes are not recognized.
    for (input, expected, tail) in [
      ("42!", 42, "!"), ("052!", 42, "!"), ("0x2a!", 42, "!"),
      ("+0X2A!", 42, "!"), ("-052!", -42, "!"), ("-0x2a!", -42, "!"),
      ("0", 0, ""), ("00!", 0, "!"), ("09", 0, "9"), ("078", 7, "8"),
      ("0b11", 0, "b11"), ("-0B11", 0, "B11"), ("0o17", 0, "o17"),
      ("12abc", 12, "abc"), ("00x1", 0, "x1"),
    ] {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerAuto
        XCTAssertEqual(Int.stdin, expected, input)
        for byte in tail.utf8 { XCTAssertEqual(_getchar_unlocked(), Int32(byte), input) }
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(input)
    }
  }

  func testAutoMixedBasesAndModeSwitch() throws {
    try SolverRunner {
      let saved = _fastio_integer_mode
      defer { _fastio_integer_mode = saved }
      _fastio_integer_mode = FastIOIntegerAuto
      XCTAssertEqual(Int.stdin, 42)
      XCTAssertEqual(Int.stdin, 42)
      XCTAssertEqual(Int.stdin, 42)
      _fastio_integer_mode = FastIOIntegerDecimal
      XCTAssertEqual(Int.stdin, 52)
      _fastio_integer_mode = FastIOIntegerAuto
      XCTAssertEqual(Int.stdin, 42)
    }.exactInput("42 052 0x2a 052 052")
  }

  func testAutoIntegerLimits() throws {
    for (radix, prefix) in [(10, ""), (8, "0"), (16, "0x")] {
      try SolverRunner {
        let saved = _fastio_integer_mode
        defer { _fastio_integer_mode = saved }
        _fastio_integer_mode = FastIOIntegerAuto
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
          let saved = _fastio_integer_mode
          defer { _fastio_integer_mode = saved }
          _fastio_integer_mode = FastIOIntegerAuto
          XCTAssertEqual(Int128.stdin, Int128.min)
          XCTAssertEqual(UInt128.stdin, UInt128.max)
        }.exactInput("-" + prefix + String(Int128.min.magnitude, radix: radix)
          + " " + prefix + String(UInt128.max, radix: radix))
      }
    }
  }

}
