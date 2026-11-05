import IOReader
import TestingUtil
import XCTest
import _FastIO

#if GCC_LIKE_FLOAT_INPUT && !LLVM_FLOAT_INPUT
final class GCCLikeFloatingPointTests: IOReaderTests {
  func testHexPrefixIsLeftInInput() throws {
    for (input, remaining) in [
      ("0x1p2", "x1p2"), ("0X1P2", "X1P2"),
      ("+0x1p2", "x1p2"), ("-0x1p2", "x1p2"),
    ] {
      try SolverRunner {
        let value = try Double.read()
        XCTAssertEqual(value, 0, input)
        XCTAssertEqual(value.sign, input.first == "-" ? .minus : .plus, input)
        for c in remaining.utf8 { XCTAssertEqual(_getchar_unlocked(), Int32(c), input) }
        XCTAssertEqual(_getchar_unlocked(), EOF, input)
      }.exactInput(input)
    }
  }

  func testOtherSpecificSyntaxIsPreserved() throws {
    for (input, expected, remaining) in [
      ("12abc", 12.0, "abc"), ("1.25e2!", 125.0, "!"),
      ("0.5!", 0.5, "!"), ("0e2!", 0.0, "!"),
    ] {
      try SolverRunner {
        XCTAssertEqual(try Double.read(), expected, input)
        for c in remaining.utf8 { XCTAssertEqual(_getchar_unlocked(), Int32(c), input) }
        XCTAssertEqual(_getchar_unlocked(), EOF, input)
      }.exactInput(input)
    }
    try SolverRunner {
      XCTAssertTrue(try Double.read().isInfinite)
      XCTAssertTrue(try Double.read().isNaN)
      XCTAssertEqual(_getchar_unlocked(), EOF)
    }.exactInput("inf nan")
  }
}
#endif
