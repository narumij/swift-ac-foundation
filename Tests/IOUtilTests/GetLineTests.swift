import IOUtil
import TestingUtil
import XCTest

final class GetLineTests: XCTestCase {

  func testGetlineProvidesLineBytesAndCount() throws {
    var captured: String = ""

    try SolverRunner {
      captured = try getline { start, count in
        String(decoding: UnsafeBufferPointer(start: start, count: count), as: UTF8.self)
      }
    }.inputOnly("abc def")

    XCTAssertEqual(captured, "abc def\n")
  }

  func testGetlinePropagatesTransformError() throws {
    let runner = SolverRunner {
      XCTAssertThrowsError(
        try getline { _, _ in
          throw SampleError.expected
        }
      ) { error in
        XCTAssertEqual(error as? SampleError, .expected)
      }
    }

    try runner.inputOnly("1 2 3")
  }

  func testReadIntLineHandlesLeadingRepeatedAndTrailingSpaces() throws {
    try SolverRunner {
      let values: [Int] = readIntLine()
      XCTAssertEqual(values, [-10, 0, 20])
    }.inputOnly("   -10   0 20   ")
  }

  func testReadUIntLineHandlesLeadingRepeatedAndTrailingSpaces() throws {
    try SolverRunner {
      let values: [UInt] = readUIntLine()
      XCTAssertEqual(values, [10, 0, 20])
    }.inputOnly("   10   0 20   ")
  }

  private enum SampleError: Error, Equatable {
    case expected
  }
}
