import XCTest
@testable import AcFoundation
import simd

final class AcFoundationTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testBinarySearch() throws {
        let array = [1, 3, 5, 7, 9]
        
        XCTAssertEqual(0, array.left(0))
        XCTAssertEqual(0, array.right(0))
        
        XCTAssertEqual(0, array.left(1))
        XCTAssertEqual(1, array.right(1))
        
        XCTAssertEqual(1, array.left(2))
        XCTAssertEqual(1, array.right(2))
        
        XCTAssertEqual(1, array.left(3))
        XCTAssertEqual(2, array.right(3))
        
        XCTAssertEqual(2, array.left(4))
        XCTAssertEqual(2, array.right(4))
        
        XCTAssertEqual(2, array.left(5))
        XCTAssertEqual(3, array.right(5))
        
        XCTAssertEqual(3, array.left(6))
        XCTAssertEqual(3, array.right(6))
    }
    
    func testVector() throws {
        
        XCTAssertEqual([1,1], [0,1] &+ [1,0])
        XCTAssertEqual([-1,1], [0,1] &- [1,0])
        
        XCTAssertEqual(dot([0,1] as SIMD2<Float>, [1,0] as SIMD2<Float>), dot([0,1],[1,0]))
        XCTAssertEqual(length_squared([0,1] as SIMD2<Float>), length_squared([0,1]))
    }
}
