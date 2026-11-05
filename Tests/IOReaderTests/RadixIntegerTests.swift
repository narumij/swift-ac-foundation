import IOReader
import TestingUtil
import XCTest
import _FastIO

final class RadixIntegerTests: IOReaderTests {
  func testEveryRadixAndDigit() throws {
    for radix in 2...16 {
      for value in 0..<radix {
        let digits = String(radix + value, radix: radix)
        for token in [digits, digits.uppercased()] {
          try SolverRunner {
            XCTAssertEqual(try Int.read(radix: radix), radix + value)
            XCTAssertEqual(_getchar_unlocked(), Int32(UInt8(ascii: "!")))
            XCTAssertEqual(_getchar_unlocked(), EOF)
          }.exactInput(token + "!")
        }
      }
    }
  }

  func testSignsWhitespaceAndUnsignedNegation() throws {
    for radix in 2...16 {
      let digits = String(31, radix: radix)
      for whitespace in [" ", "\t", "\n", "\r", "\u{0B}", "\u{0C}"] {
        try SolverRunner {
          XCTAssertEqual(try Int.read(radix: radix), -31)
          XCTAssertEqual(_getchar_unlocked(), Int32(whitespace.utf8.first!))
          XCTAssertEqual(try UInt.read(radix: radix), 31)
          XCTAssertEqual(try UInt.read(radix: radix), UInt.max)
          XCTAssertEqual(_getchar_unlocked(), EOF)
        }.exactInput(whitespace + "-" + digits + whitespace + "+" + digits + " -1")
      }
    }
  }

  func testInvalidDigitStopsAndRemains() throws {
    let digits = Array("0123456789abcdefg".utf8)
    for radix in 2...16 {
      let suffix = String(UnicodeScalar(digits[radix])) + "z"
      try SolverRunner {
        XCTAssertEqual(try Int.read(radix: radix), radix)
        for c in suffix.utf8 { XCTAssertEqual(_getchar_unlocked(), Int32(c)) }
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput("10" + suffix)
      try SolverRunner {
        XCTAssertThrowsError(try Int.read(radix: radix)) {
          XCTAssertEqual($0 as? IOReaderError, .invalidInteger)
        }
        for c in suffix.utf8 { XCTAssertEqual(_getchar_unlocked(), Int32(c)) }
      }.exactInput("+" + suffix)
    }
  }

  func testExplicitRadixDoesNotInterpretPrefixes() throws {
    for (radix, input, suffix) in [(2, "0b11", "b11"), (16, "0xFF", "xFF")] {
      try SolverRunner {
        XCTAssertEqual(try Int.read(radix: radix), 0)
        for c in suffix.utf8 { XCTAssertEqual(_getchar_unlocked(), Int32(c)) }
      }.exactInput(input)
    }
  }

  private func checkSignedBounds<T: IOReadableInteger>(_ type: T.Type) throws {
    for radix in 2...16 {
      for value in [T.min, 0, T.max] {
        try SolverRunner {
          XCTAssertEqual(try T.read(radix: radix), value)
          XCTAssertEqual(_getchar_unlocked(), EOF)
        }.exactInput(String(value, radix: radix))
      }
      for input in [String(T.max.magnitude + 1, radix: radix),
                    "-" + String(T.min.magnitude + 1, radix: radix)] {
        try SolverRunner {
          XCTAssertThrowsError(try T.read(radix: radix)) {
            XCTAssertEqual($0 as? IOReaderError, .integerOutOfRange)
          }
          XCTAssertEqual(_getchar_unlocked(), Int32(UInt8(ascii: "!")))
          XCTAssertEqual(_getchar_unlocked(), EOF)
        }.exactInput(input + "!")
      }
    }
  }

  private func checkUnsignedBounds<T: IOReadableUnsignedInteger>(_ type: T.Type) throws {
    for radix in 2...16 {
      try SolverRunner {
        XCTAssertEqual(try T.read(radix: radix), T.max)
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(String(T.max, radix: radix))
      try SolverRunner {
        XCTAssertThrowsError(try T.read(radix: radix)) {
          XCTAssertEqual($0 as? IOReaderError, .integerOutOfRange)
        }
        XCTAssertEqual(_getchar_unlocked(), Int32(UInt8(ascii: "!")))
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput("1" + String(repeating: "0", count: T.bitWidth) + "!")
    }
  }

  func testIntegerBoundsInEveryRadix() throws {
    try checkSignedBounds(Int.self)
    try checkSignedBounds(Int32.self)
    try checkSignedBounds(Int64.self)
    try checkUnsignedBounds(UInt.self)
    try checkUnsignedBounds(UInt32.self)
    try checkUnsignedBounds(UInt64.self)
    if #available(macOS 15.0, *) {
      try checkSignedBounds(Int128.self)
      try checkUnsignedBounds(UInt128.self)
    }
  }

  func testEmptyAndIncompleteInput() throws {
    try SolverRunner {
      XCTAssertThrowsError(try Int.read(radix: 16)) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
      }
    }.emptyInput()
    for input in ["+", "-"] {
      try SolverRunner {
        XCTAssertThrowsError(try Int.read(radix: 2)) {
          XCTAssertEqual($0 as? IOReaderError, .invalidInteger)
        }
        XCTAssertEqual(_getchar_unlocked(), EOF)
      }.exactInput(input)
    }
  }
}
