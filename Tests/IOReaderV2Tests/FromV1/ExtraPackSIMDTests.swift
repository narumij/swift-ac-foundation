import IOReaderV2
import Pack
import TestingUtil
import XCTest

// IOReaderExtraTests の Pack・SIMD のテストを、V2 の .stdin で移したもの。
// v1 の try .read() と .stdin の2通りは、V2 では .stdin の1通りになる。
final class ExtraPackSIMDTests: IOReaderV2TestCase {

  func testPack() throws {
    if #available(macOS 14.0, *) {
      XCTAssertEqual(
        try SolverRunner(solver: {
          let A: Pack<Character, [Character], Double> = .stdin
          print(String([A.rawValue.0]))
          print(String(A.rawValue.1))
          print(A.rawValue.2)
        })
        .run(input: "A BB 111"),
        """
        A
        BB
        111.0
        """)
    }
  }

  func testSIMD2() throws {
    try SolverRunner(solver: {
      let value: SIMD2<Int> = .stdin
      XCTAssertEqual(value.x, 1)
      XCTAssertEqual(value.y, 2)
    })
    .inputOnly("1 2")
  }

  func testSIMD3() throws {
    try SolverRunner(solver: {
      let value: SIMD3<Int> = .stdin
      XCTAssertEqual(value, SIMD3(1, 2, 3))
    })
    .inputOnly("1 2 3")
  }

  func testSIMD4() throws {
    try SolverRunner(solver: {
      let value: SIMD4<Int> = .stdin
      XCTAssertEqual(value, SIMD4(1, 2, 3, 4))
    })
    .inputOnly("1 2 3 4")
  }

  func testSIMD2Double() throws {
    try SolverRunner(solver: {
      let value: SIMD2<Double> = .stdin
      XCTAssertEqual(value.x, 1.5)
      XCTAssertEqual(value.y, 2.5)
    })
    .inputOnly("1.5 2.5")
  }

  // ここから V2 で足した組の並び（Groups）のテスト。
  func testSIMDRows() throws {
    try SolverRunner(solver: {
      let values: [SIMD2<Int>] = .stdin(rows: 3)
      XCTAssertEqual(values, [SIMD2(1, 2), SIMD2(3, 4), SIMD2(5, 6)])
    })
    .inputOnly("1 2\n3 4\n5 6")
  }

  func testSIMDRowsAsSet() throws {
    try SolverRunner(solver: {
      let values: Set<SIMD2<Int>> = .stdin(rows: 3)
      XCTAssertEqual(values, [SIMD2(1, 2), SIMD2(3, 4)])
    })
    .inputOnly("1 2\n3 4\n1 2")
  }

  func testPackRows() throws {
    if #available(macOS 14.0, *) {
      try SolverRunner(solver: {
        let values: [Pack<Int, String>] = .stdin(rows: 2)
        XCTAssertEqual(values.map(\.rawValue.0), [1, 2])
        XCTAssertEqual(values.map(\.rawValue.1), ["a", "b"])
      })
      .inputOnly("1 a\n2 b")
    }
  }
}
