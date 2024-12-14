import XCTest

#if DEBUG
  @testable import AcFoundation
#else
  //import AcFoundation
  import Bisect
#endif

final class AcFoundationTests: XCTestCase {
  func testExample() throws {
    // XCTest Documentation
    // https://developer.apple.com/documentation/xctest

    // Defining Test Cases and Test Methods
    // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
  }

  #if DEBUG
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
  #endif
}
