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
      XCTAssertEqual([[Int]].stdin(rows: 1, check: .strict), [[11, 12]])
      XCTAssertEqual([Int].stdin(rows: 2, check: .none), [13, 14])
    }).inputOnly("1\n2\n3 4\n5 6\n7 8\n9 10\n11 12\n13 14\n")
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
