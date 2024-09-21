//
//  SIMDTests.swift
//  AcFoundation
//
//  Created by narumij on 2024/09/22.
//

import XCTest

final class SIMDTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSIMD2_smoke() throws {
        var s = SIMD2<Int>()
        XCTAssertEqual(s.scalarCount, 2)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i],0)
            s[i] = i
            XCTAssertEqual(s[i], i)
        }
    }
    
    func testSIMD3_smoke() throws {
        var s = SIMD3<Int>()
        XCTAssertEqual(s.scalarCount, 3)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i],0)
            s[i] = i
            XCTAssertEqual(s[i], i)
        }
    }
    
    func testSIMD4_smoke() throws {
        var s = SIMD4<Int>()
        XCTAssertEqual(s.scalarCount, 4)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i],0)
            s[i] = i
            XCTAssertEqual(s[i], i)
        }
    }
    
    func testSIMD8_smoke() throws {
        var s = SIMD8<Int>()
        XCTAssertEqual(s.scalarCount, 8)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i],0)
            s[i] = i
            XCTAssertEqual(s[i], i)
        }
    }

    func testSIMD16_smoke() throws {
        var s = SIMD16<Int>()
        XCTAssertEqual(s.scalarCount, 16)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i],0)
            s[i] = i
            XCTAssertEqual(s[i], i)
        }
    }

    func testSIMD32_smoke() throws {
        var s = SIMD32<Int>()
        XCTAssertEqual(s.scalarCount, 32)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i],0)
            s[i] = i
            XCTAssertEqual(s[i], i)
        }
    }
    
    func testSIMD2_literal() throws {
        let s: SIMD2<Int> = [0,1]
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1]
            .description)
    }
    
    func testSIMD3_literal() throws {
        let s: SIMD3<Int> = [0,1,2]
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2]
            .description)
    }

    func testSIMD4_literal() throws {
        let s: SIMD4<Int> = [0,1,2,3]
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3]
            .description)
    }

    func testSIMD8_literal() throws {
        let s: SIMD8<Int> = [0,1,2,3,4,5,6,7]
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3,4,5,6,7]
            .description)
    }

    func testSIMD16_literal() throws {
        let s: SIMD16<Int> = [0,1,2,3,4,5,6,7,
                              8,9,10,11,12,13,14,15]
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3,4,5,6,7,
                        8,9,10,11,12,13,14,15]
            .description)
    }
    
    func testSIMD32_literal() throws {
        let s: SIMD32<Int> = [0,1,2,3,4,5,6,7,
                              8,9,10,11,12,13,14,15,
                              16,17,18,19,20,21,22,23,
                              24,25,26,27,28,29,30,31]
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3,4,5,6,7,
                        8,9,10,11,12,13,14,15,
                        16,17,18,19,20,21,22,23,
                        24,25,26,27,28,29,30,31]
            .description)
    }

    func testSIMD2_init() throws {
        let s = SIMD2<Int>(x: 0, y: 1)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1]
            .description)
    }
    
    func testSIMD3_init() throws {
        let s = SIMD3<Int>(x: 0, y: 1, z: 2)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2]
            .description)
    }
    
    func testSIMD4_init() throws {
        let s = SIMD4<Int>(x: 0, y: 1, z: 2, w: 3)
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3]
            .description)
    }

    func testSIMD8_init() throws {
        let s = SIMD8<Int>(
            v0: 0, v1: 1, v2: 2, v3: 3,
            v4: 4, v5: 5, v6: 6, v7: 7
        )
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3,4,5,6,7]
            .description)
    }

    func testSIMD16_init() throws {
        let s = SIMD16<Int>(
            v0: 0, v1: 1, v2: 2, v3: 3,
            v4: 4, v5: 5, v6: 6, v7: 7,
            v8: 8, v9: 9, v10: 10, v11: 11,
            v12: 12, v13: 13, v14: 14, v15: 15
            )
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3,4,5,6,7,
                        8,9,10,11,12,13,14,15]
            .description)
    }

    func testSIMD32_init() throws {
        let s = SIMD32<Int>(
            v0: 0, v1: 1, v2: 2, v3: 3,
            v4: 4, v5: 5, v6: 6, v7: 7,
            v8: 8, v9: 9, v10: 10, v11: 11,
            v12: 12, v13: 13, v14: 14, v15: 15,
            v16: 16, v17: 17, v18: 18, v19: 19,
            v20: 20, v21: 21, v22: 22, v23: 23,
            v24: 24, v25: 25, v26: 26, v27: 27,
            v28: 28, v29: 29, v30: 30, v31: 31
            )
        for i in 0..<s.scalarCount {
            XCTAssertEqual(s[i], i)
        }
        XCTAssertEqual(s.description,
                       [0,1,2,3,4,5,6,7,
                        8,9,10,11,12,13,14,15,
                        16,17,18,19,20,21,22,23,
                        24,25,26,27,28,29,30,31]
            .description)
    }

    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
