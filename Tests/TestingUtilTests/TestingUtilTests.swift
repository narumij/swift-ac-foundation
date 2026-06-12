import Foundation
import TestingUtil
import XCTest

#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

final class SolverRunnerTests: XCTestCase {

  func testRunProvidesInputAndCapturesTrimmedOutput() throws {
    let runner = SolverRunner {
      let first = readLine() ?? ""
      let second = readLine() ?? ""
      print("\(first)-\(second)")
      print("")
    }

    XCTAssertEqual(try runner.run(input: "hello\nworld"), "hello-world")
  }

  func testInputOnlyProvidesTrailingNewlineWhenMissing() throws {
    var lines: [String] = []
    let runner = SolverRunner {
      lines.append(readLine() ?? "")
    }

    try runner.inputOnly("single-line")

    XCTAssertEqual(lines, ["single-line"])
  }

  func testStdoutSilencerSuppressesOutputAndRestoresStdout() throws {
    let runner = SolverRunner {
      print("before")
      StdoutSilencer.run {
        print("hidden")
      }
      print("after")
    }

    XCTAssertEqual(
      try runner.outputOnly(),
      """
      before
      after
      """)
  }
}

final class StdinRedirectTests: XCTestCase {

  func testWithStdinRedirectedReadsFromFileAndReturnsBodyValue() throws {
    let fixture = try makeInputFile(contents: "42\n")
    defer { fixture.cleanUp() }

    let value = try withStdinRedirected(to: fixture.url) {
      readLine()
    }

    XCTAssertEqual(value, "42")
  }

  func testWithStdinRedirectedThreadSafeReadsFromFileAndReturnsBodyValue() throws {
    let fixture = try makeInputFile(contents: "thread-safe\n")
    defer { fixture.cleanUp() }

    let value = try withStdinRedirectedThreadSafe(to: fixture.url) {
      readLine()
    }

    XCTAssertEqual(value, "thread-safe")
  }

  func testWithStdinRedirectedThrowsForMissingFile() throws {
    let missingURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString, isDirectory: true)
      .appendingPathComponent("missing.txt")

    XCTAssertThrowsError(try withStdinRedirected(to: missingURL) {}) { error in
      let nsError = error as NSError
      XCTAssertEqual(nsError.domain, NSPOSIXErrorDomain)
      XCTAssertEqual(nsError.code, Int(ENOENT))
    }
  }

  func testWithStdinRedirectedRestoresStdinWhenBodyThrows() throws {
    let outer = try makeInputFile(contents: "outer-before\nouter-after\n")
    let inner = try makeInputFile(contents: "inner\n")
    defer {
      outer.cleanUp()
      inner.cleanUp()
    }

    try withStdinRedirected(to: outer.url) {
      XCTAssertEqual(readLineFromStandardInputFD(), "outer-before")

      XCTAssertThrowsError(
        try withStdinRedirected(to: inner.url) {
          XCTAssertEqual(readLineFromStandardInputFD(), "inner")
          throw SampleError.expected
        }
      ) { error in
        XCTAssertEqual(error as? SampleError, .expected)
      }

      XCTAssertEqual(readLineFromStandardInputFD(), "outer-after")
    }
  }

  private func makeInputFile(contents: String) throws -> (url: URL, cleanUp: () -> Void) {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

    let inputURL = directory.appendingPathComponent("input.txt")
    try contents.write(to: inputURL, atomically: true, encoding: .utf8)

    return (inputURL, { try? FileManager.default.removeItem(at: directory) })
  }

  private func readLineFromStandardInputFD() -> String? {
    var bytes: [UInt8] = []
    var byte: UInt8 = 0

    while read(STDIN_FILENO, &byte, 1) == 1 {
      if byte == UInt8(ascii: "\n") {
        break
      }
      bytes.append(byte)
    }

    guard !bytes.isEmpty else { return nil }
    return String(decoding: bytes, as: UTF8.self)
  }

  private enum SampleError: Error, Equatable {
    case expected
  }
}
