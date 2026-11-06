import Foundation
import IOReader
import TestingUtil
import XCTest

final class CinCompatibleReadSeparatorTests: IOReaderTests {
  func testValueReadersLeaveEachSupportedSeparator() throws {
    for separator in [" ", "\t", "\n", "\r"] {
      try withExactInput(["-12", "34", "1.25", "word", "bytes", "chars", ""].joined(separator: separator)) {
        let byte = Int32(separator.utf8.first!)
        XCTAssertEqual(Int.stdin, -12)
        XCTAssertEqual(getchar_unlocked(), byte)
        XCTAssertEqual(try CUnsignedInt.read(), 34)
        XCTAssertEqual(getchar_unlocked(), byte)
        XCTAssertEqual(Double.stdin, 1.25)
        XCTAssertEqual(getchar_unlocked(), byte)
        XCTAssertEqual(String.stdin(read: .word), "word")
        XCTAssertEqual(getchar_unlocked(), byte)
        XCTAssertEqual(try [UInt8].read(), Array("bytes".utf8))
        XCTAssertEqual(getchar_unlocked(), byte)
        XCTAssertEqual(try [Character].read(), Array("chars"))
        XCTAssertEqual(getchar_unlocked(), byte)
        XCTAssertEqual(getchar_unlocked(), -1)
      }
    }
  }

  func testPhysicalLineStartsAtPreservedSeparator() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(try Int.read(), 12)
      XCTAssertEqual(try String.read(read: .line), "")
      XCTAssertEqual(try Double.read(), 1.25)
      XCTAssertEqual(try String.read(read: .line), " rest")
      XCTAssertEqual(try String.read(), "word")
      XCTAssertEqual(try String.read(read: .line), "\ttail")
      XCTAssertEqual(try String.read(read: .line), "last")
    }).inputOnly("12\n1.25 rest\nword\ttail\nlast\n")
  }

  func testRepeatedValueReadsSkipThePreservedSeparator() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(try [Int].read(columns: 3), [1, 2, 3])
      XCTAssertEqual(try String.read(read: .line), "")
      XCTAssertEqual(try [UInt].read(rows: 2), [4, 5])
      XCTAssertEqual(try String.read(read: .line), " tail")
    }).inputOnly("1  2\t3\n4\n5 tail\n")
  }

  func testElementLinesStillConsumeTheirNewline() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(try [Int].read(columns: 2, check: .strict), [1, 2])
      XCTAssertEqual(try String.read(read: .line), "after integers")
      XCTAssertEqual(try [Double]._readLine(), [1.5, 2.5])
      XCTAssertEqual(try String.read(read: .line), "after doubles")
      XCTAssertEqual(try [String].readLine_words(), ["a", "b"])
      XCTAssertEqual(try String.read(read: .line), "after words")
      XCTAssertEqual(try [[UInt8]].readLine_words(), [Array("c".utf8), Array("d".utf8)])
      XCTAssertEqual(try String.read(read: .line), "after bytes")
      XCTAssertEqual(try [[Character]].readLine_words(), [Array("e"), Array("f")])
      XCTAssertEqual(try String.read(read: .line), "after characters")
    }).inputOnly("1 2\nafter integers\n1.5 2.5\nafter doubles\na b\nafter words\nc d\nafter bytes\ne f\nafter characters\n")
  }

  func testValueReadersDoNotPushBackEOFSentinel() throws {
    let readers: [(String, () throws -> Void)] = [
      ("12", { XCTAssertEqual(try Int.read(), 12) }),
      ("34", { XCTAssertEqual(try CUnsignedInt.read(), 34) }),
      ("1.25", { XCTAssertEqual(try Double.read(), 1.25) }),
      ("word", { XCTAssertEqual(try String.read(), "word") }),
      ("bytes", { XCTAssertEqual(try [UInt8].read(), Array("bytes".utf8)) }),
      ("chars", { XCTAssertEqual(try [Character].read(), Array("chars")) }),
    ]
    for (input, read) in readers {
      try withExactInput(input) {
        try read()
        XCTAssertEqual(getchar_unlocked(), -1)
        XCTAssertThrowsError(try String.read()) {
          XCTAssertEqual($0 as? IOReaderError, .unexpectedEOF)
        }
      }
    }
  }

  func testFixedWidthReadsDoNotConsumeAnExtraByte() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(try String.read(columns: 2), "ab")
      XCTAssertEqual(try [UInt8].read(columns: 2), Array("cd".utf8))
      XCTAssertEqual(try [Character].read(columns: 2), Array("ef"))
      XCTAssertEqual(try String.read(read: .line), " rest")
    }).inputOnly("abcdef rest\n")
  }

  func testFixedWidthFailureDoesNotDiscardTheNextValue() throws {
    try SolverRunner(solver: {
      XCTAssertThrowsError(try String.read(columns: 3)) {
        XCTAssertEqual($0 as? IOReaderError, .unexpectedSpace)
      }
      XCTAssertEqual(try String.read(), "next")
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("ab next\n")
  }

  func testRestorePendingByteBeforeSwiftReadLine() throws {
    try SolverRunner(solver: {
      let configuration = InputConfiguration.shared
      let saved = configuration.usesPendingCharacter
      defer { configuration.usesPendingCharacter = saved }
      configuration.usesPendingCharacter = true
      XCTAssertEqual(Int.stdin, 12)
      InputConfiguration.shared.usesPendingCharacter = false
      InputConfiguration.shared.usesPendingCharacter = false // 再実行で二重に戻さない。
      XCTAssertEqual(standardReadLine(), " rest")
      XCTAssertEqual(Int.stdin, 34)
      XCTAssertEqual(getchar_unlocked(), 10)
    }).inputOnly("12 rest\n34\n")
  }

  func testStringRowsRestorePendingNewline() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, 12)
      XCTAssertEqual([String].stdin(rows: 2, strippingNewline: true), ["", "next"])
    }).inputOnly("12\nnext\n")
  }

  private func withExactInput(_ input: String, _ body: @escaping () throws -> Void) throws {
    // SolverRunner serializes stdin access, but appends LF. Use exact bytes while holding its lock.
    try SolverRunner(solver: {
      var bytes = Array(input.utf8) + [0]
      try bytes.withUnsafeMutableBytes { buffer in
        guard let file = fmemopen(buffer.baseAddress, input.utf8.count, "r") else {
          throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
        }
        let original = stdin
        stdin = file
        defer {
          stdin = original
          fclose(file)
        }
        try body()
      }
    }).inputOnly("")
  }
}
