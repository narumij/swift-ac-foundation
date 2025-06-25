@preconcurrency import XCTest

#if DEBUG
  @testable import Bisect
#else
  //import AcFoundation
  import Bisect
#endif

import Miscellaneous

final class AcFoundationTests: XCTestCase {
  func testExample() throws {
    // XCTest Documentation
    // https://developer.apple.com/documentation/xctest

    // Defining Test Cases and Test Methods
    // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    print("stderr", to: &stderr)
  }

  func testBinarySearch() throws {
    let array = [1, 3, 5, 7, 9]

    XCTAssertEqual(0, array.bisectLeft(0))
    XCTAssertEqual(0, array.bisectRight(0))

    XCTAssertEqual(0, array.bisectLeft(1))
    XCTAssertEqual(1, array.bisectRight(1))

    XCTAssertEqual(1, array.bisectLeft(2))
    XCTAssertEqual(1, array.bisectRight(2))

    XCTAssertEqual(1, array.bisectLeft(3))
    XCTAssertEqual(2, array.bisectRight(3))

    XCTAssertEqual(2, array.bisectLeft(4))
    XCTAssertEqual(2, array.bisectRight(4))

    XCTAssertEqual(2, array.bisectLeft(5))
    XCTAssertEqual(3, array.bisectRight(5))

    XCTAssertEqual(3, array.bisectLeft(6))
    XCTAssertEqual(3, array.bisectRight(6))
  }
  
  func testInteger() throws {
    
    XCTAssertEqual(floor(10, 3), 3)
    XCTAssertEqual(ceil(10, 3), 4)
    XCTAssertEqual(mod(10, 3), 1)
    
    XCTAssertEqual(floor(-10, 3), -4)
    XCTAssertEqual(ceil(-10, 3), -3)
    XCTAssertEqual(mod(-10, 3), 2)
  }
}
