// Tests/IndexHelperTests.swift
import XCTest
import Miscellaneous

final class IndexHelperTests: XCTestCase {

    // ------------------------------
    // 2D
    // ------------------------------
    func test2DCount() {
        let w = 17, h = 9
        let helper = IndexHelper2D(w, h)
        XCTAssertEqual(helper.count, w * h)
    }

    func test2DSubscriptMapping() {
        let w = 5, h = 4
        let helper = IndexHelper2D(w, h)

        for y in 0..<h {
            for x in 0..<w {
                // z はダミー値（IndexHelper2D では無視される）
                let expected = x + y * w
                XCTAssertEqual(helper[x, y, 0], expected,
                               "Mismatch at (x: \(x), y: \(y))")
            }
        }
    }

    // ------------------------------
    // 3D
    // ------------------------------
    func test3DCount() {
        let w = 7, h = 6, d = 3
        let helper = IndexHelper3D(w, h, d)
        XCTAssertEqual(helper.count, w * h * d)
    }

    func test3DSubscriptMapping() {
        let w = 4, h = 3, d = 2
        let helper = IndexHelper3D(w, h, d)

        for z in 0..<d {
            for y in 0..<h {
                for x in 0..<w {
                    let expected = x + y * w + z * w * h
                    XCTAssertEqual(helper[x, y, z], expected,
                                   "Mismatch at (x: \(x), y: \(y), z: \(z))")
                }
            }
        }
    }
}
