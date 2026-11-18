import IOReader
import TestingUtil
import XCTest

private struct NoncopyableMatrix: ~Copyable, Numeric2D {
  typealias Element = [Int]
  let values: [[Int]]
  init<S: Sequence>(_ sequence: S) where S.Element == Element {
    values = Array(sequence)
  }
}

private struct NoncopyableWords: ~Copyable, Word1D {
  typealias Element = [UInt8]
  let values: [[UInt8]]
  init<S: Sequence>(_ sequence: S) where S.Element == Element {
    values = Array(sequence)
  }
}

private struct NoncopyableWordRows: ~Copyable, Word2D {
  typealias Element = [[UInt8]]
  let values: [[[UInt8]]]
  init<S: Sequence>(_ sequence: S) where S.Element == Element {
    values = Array(sequence)
  }
}

private struct Pair: Group, Equatable {
  let first: Int
  let second: Int
  static func read() throws -> (value: Self, separator: UInt8?) {
    let first = try Int.read()
    let second = try Int.read()
    return (Self(first: first.value, second: second.value), second.separator)
  }
}

private struct NoncopyableGroups: ~Copyable, Groups {
  typealias Element = Pair
  let values: [Pair]
  init<S: Sequence>(_ sequence: S) where S.Element == Element {
    values = Array(sequence)
  }
}

final class NoncopyableInputContainerTests: IOReaderTestCase {
  func testNumericRows() throws {
    try SolverRunner {
      let matrix = NoncopyableMatrix.stdin(rows: 2)
      XCTAssertEqual(matrix.values, [[1, -2], [3]])
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("1 -2\n3\n9\n")
  }

  func testNumericRowsAndColumns() throws {
    try SolverRunner {
      let matrix = NoncopyableMatrix.stdin(rows: 2, columns: 2)
      XCTAssertEqual(matrix.values, [[1, -2], [3, 4]])
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("1 -2\n3 4\n9\n")
  }

  func testWords() throws {
    try SolverRunner {
      let line = NoncopyableWords.stdin()
      let columns = NoncopyableWords.stdin(columns: 2)
      XCTAssertEqual(line.values, [Array("ab".utf8), Array("cd".utf8)])
      XCTAssertEqual(columns.values, [Array("ef".utf8), Array("gh".utf8)])
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("ab cd\nef gh\n9\n")
  }

  func testWordRows() throws {
    try SolverRunner {
      let rows = NoncopyableWordRows.stdin(rows: 2)
      XCTAssertEqual(rows.values, [[Array("ab".utf8)], [Array("cd".utf8), Array("ef".utf8)]])
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("ab\ncd ef\n9\n")
  }

  func testWordRowsAndColumns() throws {
    try SolverRunner {
      let rows = NoncopyableWordRows.stdin(rows: 2, columns: 1)
      XCTAssertEqual(rows.values, [[Array("ab".utf8)], [Array("cd".utf8)]])
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("ab\ncd\n9\n")
  }

  func testGroups() throws {
    try SolverRunner {
      let groups = NoncopyableGroups.stdin(rows: 2)
      XCTAssertEqual(groups.values, [Pair(first: 1, second: 2), Pair(first: -3, second: 4)])
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("1 2\n-3 4\n9\n")
  }

  func testZeroCountsDoNotConsumeInput() throws {
    try SolverRunner {
      let matrix = NoncopyableMatrix.stdin(rows: 0)
      let fixedMatrix = NoncopyableMatrix.stdin(rows: 0, columns: 2)
      let words = NoncopyableWords.stdin(columns: 0)
      let rows = NoncopyableWordRows.stdin(rows: 0)
      let fixedRows = NoncopyableWordRows.stdin(rows: 0, columns: 2)
      let groups = NoncopyableGroups.stdin(rows: 0)
      XCTAssertTrue(matrix.values.isEmpty)
      XCTAssertTrue(fixedMatrix.values.isEmpty)
      XCTAssertTrue(words.values.isEmpty)
      XCTAssertTrue(rows.values.isEmpty)
      XCTAssertTrue(fixedRows.values.isEmpty)
      XCTAssertTrue(groups.values.isEmpty)
      XCTAssertEqual(Int.stdin, 9)
    }.inputOnly("9\n")
  }
}
