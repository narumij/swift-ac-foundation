import struct IOBase.InputConfiguration
import IOReader
import IOReaderExtra
import Pack
import TestingUtil
import XCTest

private struct ConvertedInt: IOConversion, IOReader.Numeric, Equatable {
  let value: Int
  static func read() throws -> (value: Self, separator: UInt8?) {
    try readTuple { (value: Int) in Self(value: value) }
  }
}

final class ConversionSeparatorTests: IOReaderTestCase {
  func testSingleReadConsumesNewlineButPreservesEmptyLine() throws {
    for pending in [false, true] {
      try SolverRunner(solver: {
        InputConfiguration.shared.usesPendingCharacter = pending
        XCTAssertEqual(Int.stdin, 12)
        XCTAssertEqual([UInt8].readLine(), [])
        XCTAssertEqual(String.readLine(), "abc")
        XCTAssertEqual(String.stdin, "word")
        XCTAssertEqual(String.readLine(), "next")
      }).inputOnly("12\n\nabc\nword\nnext\n")
    }
  }

  func testConvertedValuesKeepLineBoundary() throws {
    try SolverRunner(solver: {
      XCTAssertEqual([ConvertedInt].stdin().map(\.value), [1, 2])
      XCTAssertEqual([ConvertedInt].stdin(columns: 2).map(\.value), [3, 4])
      XCTAssertEqual(ConvertedInt.stdin.value, 5)
      XCTAssertEqual(String.readLine(), "next")
    }).inputOnly("1 2\n3 4\n5\nnext\n")
  }

  func testNestedSIMDAndPackKeepLineBoundary() throws {
    try SolverRunner(solver: {
      XCTAssertEqual([SIMD2<Int>].stdin(), [SIMD2(1, 2), SIMD2(3, 4)])
      XCTAssertEqual([SIMD2<Int>].stdin(), [SIMD2(5, 6)])
      let packs = [Pack2<Int, SIMD2<Int>>].stdin(rows: 2)
      XCTAssertEqual(packs[0].rawValue.0, 7)
      XCTAssertEqual(packs[0].rawValue.1, SIMD2(8, 9))
      XCTAssertEqual(packs[1].rawValue.0, 10)
      XCTAssertEqual(packs[1].rawValue.1, SIMD2(11, 12))
      XCTAssertEqual(String.readLine(), "next")
    }).inputOnly("1 2 3 4\n5 6\n7 8 9\n10 11 12\nnext\n")
  }

  func testTupleConsumesNewlineAndKeepsNonSeparator() throws {
    try SolverRunner(solver: {
      let pair: (Int, Int) = stdin()
      XCTAssertEqual(pair.0, 1)
      XCTAssertEqual(pair.1, 2)
      XCTAssertEqual(String.readLine(), "next")
      XCTAssertEqual(Int.stdin, 123)
      XCTAssertEqual(String.readLine(), "abc")
    }).inputOnly("1 2\nnext\n123abc\n")
  }

  func testConversionReturnsEOF() throws {
    struct FinalValue: Component {
      static func read() throws -> (value: Self, separator: UInt8?) {
        (Self(), nil)
      }
    }
    let item: (value: FinalValue, separator: UInt8?) = try ConvertedInt.readTuple()
    XCTAssertNil(item.separator)
  }
}
