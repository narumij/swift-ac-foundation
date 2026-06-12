import Miscellaneous
import XCTest

final class IntegerTests: XCTestCase {

  func testInteger() throws {

    XCTAssertEqual(floor(10, 3), 3)
    XCTAssertEqual(ceil(10, 3), 4)
    XCTAssertEqual(mod(10, 3), 1)

    XCTAssertEqual(floor(-10, 3), -4)
    XCTAssertEqual(ceil(-10, 3), -3)
    XCTAssertEqual(mod(-10, 3), 2)
  }
}
