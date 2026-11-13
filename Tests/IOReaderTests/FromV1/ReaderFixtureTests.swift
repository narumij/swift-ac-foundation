import Foundation
import IOReader
import TestingUtil
import Testing

// ReaderFixtureTests.swift を移したもの。読めるケースは値を確かめ、v1 で throw していたケースは exit test で停止を確かめる。
// 入力ファイルは v1 のテストの Resources をそのまま使う。
private func fixture(_ name: String) -> URL {
  URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("IOReaderTests")
    .appendingPathComponent("Resources")
    .appendingPathComponent(name)
}

struct ReaderFixtureTests {

  @Test func oneLineInt() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineInt.txt")) { Int.stdin }
    #expect(value == 1000)
  }

  @Test func oneLineDouble() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineDouble.txt")) { Double.stdin }
    #expect(abs(value - 0.1234) < 0.0001)
  }

  @Test func oneLineString() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { String.stdin }
    #expect(value == "TakahashiAoki")
  }

  @Test func oneLineStringColumns() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { String.stdin(columns: 13) }
    #expect(value == "TakahashiAoki")
  }

  @Test func oneLineCharacters() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { [Character].stdin }
    #expect(value == Array("TakahashiAoki"))
  }

  @Test func oneLineCharactersColumns() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { [Character].stdin(columns: 13) }
    #expect(value == Array("TakahashiAoki"))
  }

  @Test func oneLineBytes() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { [UInt8].stdin }
    #expect(value == Array("TakahashiAoki".utf8))
  }

  @Test func oneLineBytesColumns() throws {
    let value = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { [UInt8].stdin(columns: 13) }
    #expect(value == Array("TakahashiAoki".utf8))
  }

  @Test func spacesIntStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { Int.stdin }
    }
  }

  @Test func emptyIntStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { Int.stdin }
    }
  }

  @Test func spacesDoubleStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { Double.stdin }
    }
  }

  @Test func emptyDoubleStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { Double.stdin }
    }
  }

  @Test func spacesStringStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { String.stdin }
    }
  }

  @Test func emptyStringStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { String.stdin }
    }
  }

  @Test func spacesCharactersStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { [Character].stdin }
    }
  }

  @Test func emptyCharactersStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { [Character].stdin }
    }
  }

  @Test func spacesBytesStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { [UInt8].stdin }
    }
  }

  @Test func emptyBytesStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { [UInt8].stdin }
    }
  }

  @Test func spacesStringColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { String.stdin(columns: 13) }
    }
  }

  @Test func emptyStringColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { String.stdin(columns: 13) }
    }
  }

  @Test func spacesCharactersColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { [Character].stdin(columns: 13) }
    }
  }

  @Test func emptyCharactersColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { [Character].stdin(columns: 13) }
    }
  }

  @Test func spacesBytesColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Spaces.txt")) { [UInt8].stdin(columns: 13) }
    }
  }

  @Test func emptyBytesColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("Empty.txt")) { [UInt8].stdin(columns: 13) }
    }
  }

  @Test func oneLineStringTooManyColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { String.stdin(columns: 14) }
    }
  }

  @Test func oneLineCharactersTooManyColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { [Character].stdin(columns: 14) }
    }
  }

  @Test func oneLineBytesTooManyColumnsStops() async {
    await #expect(processExitsWith: .failure) {
      _ = try withStdinRedirectedThreadSafe(to: fixture("OneLineString.txt")) { [UInt8].stdin(columns: 14) }
    }
  }
}
