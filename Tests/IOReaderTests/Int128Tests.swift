import IOReader
import TestingUtil
import XCTest

final class Int128Tests: IOReaderTestCase {

  func testInt128() throws {
    if #available(macOS 15.0, *) {
      try SolverRunner(solver: {
        XCTAssertEqual(Int128.stdin, Int128.min)
        XCTAssertEqual(UInt128.stdin, UInt128.max)
        XCTAssertEqual([Int128].stdin(), [1, -2])
      }).inputOnly("\(Int128.min) \(UInt128.max)\n1 -2\n")
    }
  }
}

final class InlineArrayTests: IOReaderTestCase {

  func testInlineArray() throws {
    if #available(macOS 26.0, *) {
      try SolverRunner(solver: {
        let a: InlineArray<3, Int> = .stdin
        XCTAssertEqual([a[0], a[1], a[2]], [1, 2, 3])
        let rows: [InlineArray<2, Int>] = .stdin(rows: 2)
        XCTAssertEqual(rows.map { [$0[0], $0[1]] }, [[4, 5], [6, 7]])
      }).inputOnly("1 2 3\n4 5\n6 7\n")
    }
  }
}
