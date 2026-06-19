import IOReader
import TestingUtil
import UInt8Util
import XCTest

final class IOReaderCRLFTests: XCTestCase {

  func testRawReadLineStripsCRLF() throws {
    // 修正前の `[UInt8].readLine(strippingNewline: true)` と
    // `[Character].readLine(strippingNewline: true)` は LF だけを削っていた。
    // CRLF 入力では `\r` が末尾に残り、UInt8 版は末尾 byte 13 を含んで
    // このテストが赤になった。修正では LF を削った後、直前に CR があれば
    // それも削るようにして、Swift.readLine と同じ感覚で使えるようにした。
    try SolverRunner(solver: {
      let bytes = [UInt8].readLine()!
      let characters = [Character].readLine()!
      XCTAssertEqual(bytes, "Takahashi Aoki".asciiValues)
      XCTAssertEqual(String(characters), "Tanaka Aoi")
    })
    .inputOnly("Takahashi Aoki\r\nTanaka Aoi")
  }
}
