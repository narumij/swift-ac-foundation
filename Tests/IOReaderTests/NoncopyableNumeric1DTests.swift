import IOReader
import TestingUtil
import XCTest

private struct NoncopyableNumbers: ~Copyable, IOReader.Numeric1D {
  typealias Element = Int
  var values: [Int]

  init<S: Sequence>(_ sequence: S) where S.Element == Int {
    values = Array(sequence)
  }
}

final class NoncopyableNumeric1DTests: IOReaderTestCase {
  func testLine() throws {
    try SolverRunner {
      let numbers = NoncopyableNumbers.stdin()
      XCTAssertEqual(numbers.values, [1, -2, 3])
      XCTAssertEqual(Int.stdin, 4)
    }.inputOnly("1 -2 3\n4\n")
  }

  func testColumns() throws {
    try SolverRunner {
      let numbers = NoncopyableNumbers.stdin(columns: 3)
      XCTAssertEqual(numbers.values, [1, -2, 3])
      XCTAssertEqual(Int.stdin, 4)
    }.inputOnly("1 -2 3\n4\n")
  }

  func testRows() throws {
    try SolverRunner {
      let numbers = NoncopyableNumbers.stdin(rows: 3)
      XCTAssertEqual(numbers.values, [1, -2, 3])
      XCTAssertEqual(Int.stdin, 4)
    }.inputOnly("1\n-2\n3\n4\n")
  }

  func testZeroCountDoesNotConsumeInput() throws {
    try SolverRunner {
      let columns = NoncopyableNumbers.stdin(columns: 0)
      let rows = NoncopyableNumbers.stdin(rows: 0)
      XCTAssertTrue(columns.values.isEmpty)
      XCTAssertTrue(rows.values.isEmpty)
      XCTAssertEqual(Int.stdin, 4)
    }.inputOnly("4\n")
  }
}
