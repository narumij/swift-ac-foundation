import Algorithms
import Convenience
import TestingUtil
import XCTest

final class CovenienceTests: XCTestCase {

  func testPrefixSum() throws {
    XCTAssertEqual(prefixSum((1...5) + []), (1...5).reductions(0, +))
  }

  func testPrefixSum2D() throws {
    let source = [
      [1, 2, 3],
      [4, 5, 6],
    ]

    XCTAssertEqual(
      prefixSum(source),
      [
        [0, 0, 0, 0],
        [0, 1, 3, 6],
        [0, 5, 12, 21],
      ])
  }

  func testPrefixSum3D() throws {
    let source = [
      [
        [1, 2],
        [3, 4],
      ],
      [
        [5, 6],
        [7, 8],
      ],
    ]

    XCTAssertEqual(prefixSum(source)[2][2][2], 36)
    XCTAssertEqual(prefixSum(source)[1][2][2], 10)
    XCTAssertEqual(prefixSum(source)[2][1][2], 14)
    XCTAssertEqual(prefixSum(source)[2][2][1], 16)
  }

  func testResizeCanShrinkAndExtend() throws {
    var values = [1, 2, 3]
    values.resize(2)
    XCTAssertEqual(values, [1, 2])

    values.resize(5)
    XCTAssertEqual(values, [1, 2, 0, 0, 0])

    XCTAssertEqual([1, 2].resized(4), [1, 2, 0, 0])
  }

  func testTransposedJaggedSequenceStopsAtShortestRow() throws {
    let source = [
      [1, 2, 3],
      [4, 5],
      [6, 7, 8, 9],
    ]

    XCTAssertEqual(source.transposed(), [[1, 4, 6], [2, 5, 7]])
  }
}
