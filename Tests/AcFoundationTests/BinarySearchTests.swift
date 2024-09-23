import XCTest
import AcFoundation

final class BinarySearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBinarySearch() throws {
        
        XCTAssertEqual((0..<10).left(-1), (0..<10).left(-1, <) { $0 })
        XCTAssertEqual((0..<10).right(-1), (0..<10).right(-1, <) { $0 })
        
        XCTAssertEqual((0..<10).left(0), (0..<10).left(0, <) { $0 })
        XCTAssertEqual((0..<10).right(0), (0..<10).right(0, <) { $0 })
        
        XCTAssertEqual((0..<10).left(5), (0..<10).left(5, <) { $0 })
        XCTAssertEqual((0..<10).right(5), (0..<10).right(5, <) { $0 })
        
        XCTAssertEqual((0..<10).left(9), (0..<10).left(9, <) { $0 })
        XCTAssertEqual((0..<10).right(9), (0..<10).right(9, <) { $0 })
        
        XCTAssertEqual((0..<10).left(10), (0..<10).left(10, <) { $0 })
        XCTAssertEqual((0..<10).right(10), (0..<10).right(10, <) { $0 })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
