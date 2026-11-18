import IOBase
import IOReaderExtra
import Pack
import IOReader
import TestingUtil
import XCTest

final class IOReaderCRLFTests: IOReaderTestCase {

  func testRawReadLineStripsCRLF() throws {
    // 修正前の `[UInt8].readLine(strippingNewline: true)` と
    // `[Character].readLine(strippingNewline: true)` は LF だけを削っていた。
    // CRLF 入力では `\r` が末尾に残り、UInt8 版は末尾 byte 13 を含んで
    // このテストが赤になった。修正では LF を削った後、直前に CR があれば
    // それも削るようにして、Swift.readLine と同じ感覚で使えるようにした。
    try SolverRunner(solver: {
      let bytes = [UInt8].readLine()
      let characters = [Character].readLine()
      XCTAssertEqual(bytes, Array("Takahashi Aoki".utf8))
      XCTAssertEqual(String(characters), "Tanaka Aoi")
    })
    .inputOnly("Takahashi Aoki\r\nTanaka Aoi")
  }

  func testValueReadConsumesWholeNewline() throws {
    for pending in [false, true] {
      for newline in ["\n", "\r\n", "\r"] {
        try SolverRunner(solver: {
          InputConfiguration.shared.usesPendingCharacter = pending
          XCTAssertEqual(Int.stdin, 12)
          XCTAssertEqual(String.readLine(), "next")
          XCTAssertEqual(String.stdin, "word")
          XCTAssertEqual([UInt8].readLine(), [])
          XCTAssertEqual(String.readLine(), "last")
        }).inputOnly("12\(newline)next\nword\(newline)\r\nlast\n")
      }
    }
  }

  func testLineAndColumnsConsumeWholeNewline() throws {
    for pending in [false, true] {
      for newline in ["\n", "\r\n", "\r"] {
        try SolverRunner(solver: {
          InputConfiguration.shared.usesPendingCharacter = pending
          XCTAssertEqual([Int].stdin(), [1, 2])
          XCTAssertEqual(String.readLine(), "next")
          XCTAssertEqual([Int].stdin(columns: 2), [3, 4])
          XCTAssertEqual(String.readLine(), "last")
        }).inputOnly("1 2 \t\(newline)next\n3 4 \t\(newline)last\n")
      }
    }
  }

  func testRowsAndGroupsConsumeWholeNewline() throws {
    for pending in [false, true] {
      try SolverRunner(solver: {
        InputConfiguration.shared.usesPendingCharacter = pending
        XCTAssertEqual([Int].stdin(rows: 2), [1, 2])
        XCTAssertEqual(String.readLine(), "ints")
        XCTAssertEqual([Double].stdin(rows: 2), [1.5, 2.5])
        XCTAssertEqual(String.readLine(), "doubles")
        let pair: (Int, Int) = stdin()
        XCTAssertEqual(pair.0, 3)
        XCTAssertEqual(pair.1, 4)
        XCTAssertEqual(String.readLine(), "tuple")
        XCTAssertEqual([Pack2<Int, Int>].stdin(rows: 1)[0].rawValue.1, 6)
        XCTAssertEqual(String.readLine(), "pack")
        XCTAssertEqual([String].stdin(rows: 1, columns: 3), ["abc"])
        XCTAssertEqual(String.readLine(), "last")
      }).inputOnly("1\r\n2\r\nints\n1.5\r\n2.5\r\ndoubles\n3 4\r\ntuple\n5 6\r\npack\nabc\r\nlast\n")
    }
  }

  func testBareCRAtEOF() throws {
    for pending in [false, true] {
      try SolverRunner(solver: {
        InputConfiguration.shared.usesPendingCharacter = pending
        XCTAssertEqual(Int.stdin, 12)
        XCTAssertThrowsError(try Int.read())
      }).inputOnly("12\r")
    }
  }
}
