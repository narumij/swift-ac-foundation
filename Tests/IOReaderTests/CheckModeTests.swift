import IOReader
import TestingUtil
import XCTest

final class CheckModeTests: XCTestCase {
  func testExistingReaders() throws {
    try SolverRunner(solver: {
      XCTAssertEqual([Int].stdin(rows: 2, check: .strict), [1, 2])
      XCTAssertEqual(try [Int].read(columns: 2, check: .strict), [3, 4])
      XCTAssertEqual([[Int]].stdin(rows: 2, columns: 2, check: .strict), [[5, 6], [7, 8]])
      XCTAssertEqual(try Set<Int>.read(check: .strict), Set([9, 10]))
      XCTAssertEqual([[Int]].stdin(rows: 1), [[11, 12]])
      XCTAssertEqual([Int].stdin(rows: 2, check: .none), [13, 14])
    }).inputOnly("1\n2\n3 4\n5 6\n7 8\n9 10\n11 12\n13 14\n")
  }

  func testSequenceConstructionPreservesInputCountChecks() throws {
    try SolverRunner(solver: {
      let unique: Set<Int> = try .read(columns: 3, check: .strict)
      XCTAssertEqual(unique, [1, 2])
      XCTAssertThrowsError(try Set<Int>.read(columns: 2, check: .strict)) {
        XCTAssertEqual($0 as? IOReaderError, .elementCountMismatch(expected: 2, actual: 3))
      }
      let rows: Set<Int> = try .read(rows: 3, check: .strict)
      XCTAssertEqual(rows, [3, 4])
      let sequence = try InputSequence<Int>.read(columns: 3)
      XCTAssertEqual(Array(sequence), [5, 6, 7])
    }).inputOnly("1 1 2\n1 1 2\n3\n3\n4\n5 6\n7\n")
  }

  func testNestedSequenceConstruction() throws {
    try SolverRunner(solver: {
      let rows: [Set<Int>] = .stdin(rows: 2, columns: 3, check: .strict)
      XCTAssertEqual(rows, [Set([1, 2]), Set([3, 4])])
      let sequences = try InputSequence<InputSequence<Int>>.read(rows: 2, columns: 2)
      XCTAssertEqual(sequences.map { Array($0) }, [[5, 6], [7, 8]])
      XCTAssertThrowsError(try [Set<Int>].read(rows: 1, columns: 2, check: .strict)) {
        XCTAssertEqual($0 as? IOReaderError, .elementCountMismatch(expected: 2, actual: 3))
      }
    }).inputOnly("1 1 2\n3 4 4\n5 6 7 8\n9 9 10\n")
  }

  func testElementCountMismatch() throws {
    try SolverRunner(solver: {
      XCTAssertThrowsError(try [Int].read(columns: 2, check: .strict)) {
        XCTAssertEqual($0 as? IOReaderError, .elementCountMismatch(expected: 2, actual: 1))
      }
      XCTAssertThrowsError(try [Int].read(rows: 1, check: .strict)) {
        XCTAssertEqual($0 as? IOReaderError, .elementCountMismatch(expected: 1, actual: 2))
      }
      XCTAssertEqual(Int.stdin, 4)
    }).inputOnly("1\n2 3\n4\n")
  }
}

// Deliberately Sequence-only: input construction must not require Collection operations.
private struct InputSequence<Element>: ExpressibleByElementSequence {
  let values: [Element]
  init(_ elements: [Element]) { values = elements }
  func makeIterator() -> Array<Element>.Iterator { values.makeIterator() }
}
