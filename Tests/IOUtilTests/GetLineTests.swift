import IOUtil
import TestingUtil
import XCTest

final class GetLineTests: XCTestCase {

  func testWithUnsafeReadLineBytesProvidesLineBytes() throws {
    var captured: String = ""

    try SolverRunner {
      captured = try withUnsafeReadLineBytes { line in
        String(decoding: line, as: UTF8.self)
      }
    }.inputOnly("abc def")

    XCTAssertEqual(captured, "abc def\n")
  }

  func testWithUnsafeReadLineBytesPropagatesBodyError() throws {
    let runner = SolverRunner {
      XCTAssertThrowsError(
        try withUnsafeReadLineBytes { _ in
          throw SampleError.expected
        }
      ) { error in
        XCTAssertEqual(error as? SampleError, .expected)
      }
    }

    try runner.inputOnly("1 2 3")
  }

  func testCCharWithUnsafeReadLineBytesProvidesLineBytes() throws {
    var captured: String = ""

    try SolverRunner {
      captured = __withUnsafeReadLineBytes { line in
        String(decoding: line, as: UTF8.self)
      }
    }.inputOnly("abc def")

    XCTAssertEqual(captured, "abc def\n")
  }

  func testCCharWithUnsafeReadLineBytesPropagatesBodyError() throws {
    let runner = SolverRunner {
      XCTAssertThrowsError(
        try __withUnsafeReadLineBytes { _ in
          throw SampleError.expected
        }
      ) { error in
        XCTAssertEqual(error as? SampleError, .expected)
      }
    }

    try runner.inputOnly("1 2 3")
  }

  func testCCharWithUnsafeReadBytesProvidesAllInputWithNullTerminator() throws {
    var captured: [UInt8] = []

    try SolverRunner {
      captured = __withUnsafeReadBytes(capacity: 4) { buffer in
        Array(buffer)
      }
    }.inputOnly("abc\ndef")

    XCTAssertEqual(captured, Array("abc\ndef\n".utf8) + [0])
  }

  private enum SampleError: Error, Equatable {
    case expected
  }
}
