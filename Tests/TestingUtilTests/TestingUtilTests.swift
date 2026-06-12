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

  // `outputOnly` は呼び出し前に stdout に残っているバッファを捕まえてはいけない。
  // Linux CI では `print("outside")` が未 flush のまま pipe 差し替え後に流れ、
  // 修正前は capture 結果が `outside\ninside` になっていた。
  // stdout を pipe に向ける前に `fflush(stdout)` できていれば、このテストは `inside` だけを読む。
  func testOutputOnlyDoesNotCapturePreviouslyBufferedStdout() throws {
    print("outside")

    let runner = SolverRunner {
      print("inside")
    }

    XCTAssertEqual(try runner.outputOnly(), "inside")
  }

  // solver が throw しても stdout は必ず元に戻す必要がある。
  // ここが壊れると、次の `outputOnly` が前回の pipe や閉じた FD に影響される。
  func testOutputOnlyRestoresStdoutWhenSolverThrows() throws {
    let throwingRunner = SolverRunner {
      print("before-throw")
      throw SampleError.expected
    }

    XCTAssertThrowsError(try throwingRunner.outputOnly()) { error in
      XCTAssertEqual(error as? SampleError, .expected)
    }

    let runner = SolverRunner {
      print("after-throw")
    }

    XCTAssertEqual(try runner.outputOnly(), "after-throw")
  }

  // `inputOnly` の実行中に solver が throw しても、stdin は外側の入力へ戻る必要がある。
  // 修正前は `try solver()` の後にしか `stdin = backup` がなく、throw 経路で復元されなかった。
  // その結果、内側の `inputOnly("inner")` 後に外側の `outer` が読めず nil になっていた。
  // `defer` で stdin 復元と `fmemopen` の FILE* close を行えば、throw 後も外側の入力を継続できる。
  func testInputOnlyRestoresStdinWhenSolverThrows() throws {
    let outer = SolverRunner {
      let throwingRunner = SolverRunner {
        XCTAssertEqual(readLine(), "inner")
        throw SampleError.expected
      }

      XCTAssertThrowsError(try throwingRunner.inputOnly("inner")) { error in
        XCTAssertEqual(error as? SampleError, .expected)
      }

      XCTAssertEqual(readLine(), "outer")
    }

    try outer.inputOnly("outer")
  }

  private enum SampleError: Error, Equatable {
    case expected
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

  // 空入力で EOF を踏んだあとでも、次の stdin 差し替えでは新しい入力を読める必要がある。
  // FD を差し替えても C の `stdin` 側に EOF/error 状態が残ると `readLine()` が即 nil になるため、
  // `withStdinRedirected` は復元時に `clearerr(stdin)` してその状態を持ち越さない。
  func testWithStdinRedirectedClearsEOFStateBeforeReading() throws {
    let empty = try makeInputFile(contents: "")
    let nonEmpty = try makeInputFile(contents: "recovered\n")
    defer {
      empty.cleanUp()
      nonEmpty.cleanUp()
    }

    try withStdinRedirected(to: empty.url) {
      XCTAssertNil(readLine())
    }

    try withStdinRedirected(to: nonEmpty.url) {
      XCTAssertEqual(readLine(), "recovered")
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
