import Algorithms
import Convenience
import TestingUtil
import XCTest

final class CovenienceTests: XCTestCase {

  func testPrefixSum() throws {
    XCTAssertEqual(prefixSum((1...5) + []), (1...5).reductions(0, +))
  }
}
