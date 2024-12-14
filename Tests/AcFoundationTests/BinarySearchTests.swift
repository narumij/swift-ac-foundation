import Bisect
import XCTest

final class BinarySearchTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testBinarySearch() throws {

    XCTAssertEqual((0..<10).bisectLeft(-1), (0..<10).bisectLeft(-1) { $0 })
    XCTAssertEqual((0..<10).bisectRight(-1), (0..<10).bisectRight(-1) { $0 })

    XCTAssertEqual((0..<10).bisectLeft(0), (0..<10).bisectLeft(0) { $0 })
    XCTAssertEqual((0..<10).bisectRight(0), (0..<10).bisectRight(0) { $0 })

    XCTAssertEqual((0..<10).bisectLeft(5), (0..<10).bisectLeft(5) { $0 })
    XCTAssertEqual((0..<10).bisectRight(5), (0..<10).bisectRight(5) { $0 })

    XCTAssertEqual((0..<10).bisectLeft(9), (0..<10).bisectLeft(9) { $0 })
    XCTAssertEqual((0..<10).bisectRight(9), (0..<10).bisectRight(9) { $0 })

    XCTAssertEqual((0..<10).bisectLeft(10), (0..<10).bisectLeft(10) { $0 })
    XCTAssertEqual((0..<10).bisectRight(10), (0..<10).bisectRight(10) { $0 })
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
