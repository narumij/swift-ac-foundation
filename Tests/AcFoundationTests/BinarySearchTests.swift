import Bisect
import XCTest

struct C {
  var value: Int
  var serial: Int
}

extension C: Comparable {
  static func < (lhs: C, rhs: C) -> Bool {
    lhs.value < rhs.value
  }
}

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
  
  func testMid() throws {
    func mid1(_ lo: Int,_ hi: Int) -> Int {
      (lo &+ hi) / 2
    }
    func mid2(_ lo: Int,_ hi: Int) -> Int {
      lo &+ (hi &- lo) / 2
    }
    XCTAssertNotEqual(mid1(Int.max, Int.max), Int.max) // オーバーフローまたはクラッシュとなる
    XCTAssertEqual(mid1(Int.max / 2, Int.max / 2), Int.max / 2)
    XCTAssertEqual(mid2(Int.max, Int.max), Int.max)
  }
  
  func testInsort1() throws {
    var list = [0,1,2,2,2,3,4].map{ C(value: $0, serial: 0) }
    list.insortLeft(C(value: 2, serial: 1))
    XCTAssertEqual(list.map{ $0.serial }, [0,0,1,0,0,0,0,0])
  }
  
  func testInsort2() throws {
    var list = [0,1,2,2,2,3,4].map{ C(value: $0, serial: 0) }
    list.insortRight(C(value: 2, serial: 1))
    XCTAssertEqual(list.map{ $0.serial }, [0,0,0,0,0,1,0,0])
  }

  func testInsort3() throws {
    var list = [0,1,2,2,2,3,4].map{ C(value: 0, serial: $0) }
    list.insortLeft(C(value: 1, serial: 2), key: { $0.serial })
    XCTAssertEqual(list.map{ $0.value }, [0,0,1,0,0,0,0,0])
  }
  
  func testInsort4() throws {
    var list = [0,1,2,2,2,3,4].map{ C(value: 0, serial: $0) }
    list.insortRight(C(value: 1, serial: 2), key: { $0.serial })
    XCTAssertEqual(list.map{ $0.value }, [0,0,0,0,0,1,0,0])
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
