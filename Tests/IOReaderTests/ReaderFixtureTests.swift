import IOReader
import Pack
import TestingUtil
import UInt8Util
import XCTest

final class ReaderFixtureTests: XCTestCase {
  func testOneLineFixtureInt() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineInt.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try Int.read()
      XCTAssertEqual(N, 1000)
    }
  }

  func testSpacesFixtureInt() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Int.read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureInt() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Int.read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureDouble() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineDouble.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try Double.read()
      XCTAssertEqual(N, 0.1234, accuracy: 0.0001)
    }
  }

  func testSpacesFixtureDouble() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Double.read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureDouble() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try Double.read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureString() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineString.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try String.read()
      XCTAssertEqual(N, "TakahashiAoki")
    }

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try String.read(columns: 13)
      XCTAssertEqual(N, "TakahashiAoki")
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 14)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testSpacesFixtureString() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 13)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureString() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try String.read(columns: 13)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureCharacters() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineString.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try [Character].read()
      XCTAssertEqual(N, Array("TakahashiAoki"))
    }

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try [Character].read(columns: 13)
      XCTAssertEqual(N, Array("TakahashiAoki"))
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [Character].read(columns: 14)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testSpacesFixtureCharacters() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [Character].read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [Character].read(columns: 13)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureCharacters() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [Character].read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [Character].read(columns: 13)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testOneLineFixtureBytes() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("OneLineString.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try [UInt8].read()
      XCTAssertEqual(N, "TakahashiAoki".compactMap(\.asciiValue))
    }

    try withStdinRedirectedThreadSafe(to: url) {
      let N = try [UInt8].read(columns: 13)
      XCTAssertEqual(N, "TakahashiAoki".compactMap(\.asciiValue))
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 14)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testSpacesFixtureBytes() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Spaces.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 13)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }

  func testEmptyFixtureBytes() throws {

    let here = URL(fileURLWithPath: #filePath)
    let url =
      here
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent("Empty.txt")

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read()) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }

    try withStdinRedirectedThreadSafe(to: url) {
      XCTAssertThrowsError(try [UInt8].read(columns: 13)) {
        XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedEOF)
      }
    }
  }
}
