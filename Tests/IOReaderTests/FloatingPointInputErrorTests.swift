import IOReader
import TestingUtil
import XCTest
@preconcurrency import _FastIO

final class FloatingPointInputErrorTests: IOReaderTests {
  func testFailedInputAndRemainingCharacterAreReported() throws {
    for (input, candidate, next, reason) in [
      ("1e+!", "1e+", UInt8(ascii: "!"), IOReaderError.invalidFloatingPoint),
      ("abc", "", UInt8(ascii: "a"), IOReaderError.invalidFloatingPoint),
      ("1e9999 ", "1e9999", UInt8(ascii: " "), IOReaderError.floatingPointOutOfRange),
    ] {
      try SolverRunner {
        let saved = _fastio_floating_point_mode
        defer { _fastio_floating_point_mode = saved }
        _fastio_floating_point_mode = FastIOFloatingPointGCCLike
        XCTAssertThrowsError(try Double.read()) {
          let error = $0 as? FloatingPointInputError
          XCTAssertEqual(error?.reason, reason)
          XCTAssertEqual(error?.input, candidate)
          XCTAssertEqual(error?.nextByte, next)
          XCTAssertTrue(String(describing: $0).contains("Double"))
          XCTAssertTrue(String(describing: $0).contains(candidate.debugDescription))
        }
        XCTAssertEqual(_getchar_unlocked(), Int32(next))
      }.exactInput(input)
    }
  }

  func testIncompleteValueAtEOFReportsCandidateWithoutTerminator() throws {
    try SolverRunner {
      XCTAssertThrowsError(try Double.read()) {
        let error = $0 as? FloatingPointInputError
        XCTAssertEqual(error?.input, "1e+")
        XCTAssertNil(error?.nextByte)
        XCTAssertTrue(String(describing: $0).contains("EOF"))
      }
      XCTAssertEqual(_getchar_unlocked(), EOF)
    }.exactInput("1e+")
  }
}
