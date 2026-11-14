import IOReader
import Pack
import TestingUtil
import XCTest

// IOReaderExtraTests の Pack・SIMD のテストを、V2 の .stdin で移したもの。
// v1 の try .read() と .stdin の2通りは、V2 では .stdin の1通りになる。
final class ExtraPackSIMDTests: IOReaderTestCase {

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

  func testPack2() throws {
    try SolverRunner(solver: {
      let value: Pack2<Int, String> = .stdin
      XCTAssertEqual(value, Pack2(1, "ab"))
    })
    .inputOnly("1 ab")
  }

  func testPack3() throws {
    try SolverRunner(solver: {
      let value: Pack3<Int, Double, String> = .stdin
      XCTAssertEqual(value, Pack3(1, 2.5, "c"))
    })
    .inputOnly("1 2.5 c")
  }

  func testPack4() throws {
    try SolverRunner(solver: {
      let value: Pack4<Int, Int, Int, Int> = .stdin
      XCTAssertEqual(value, Pack4(1, 2, 3, 4))
    })
    .inputOnly("1 2 3 4")
  }

  func testPack2Array() throws {
    try SolverRunner(solver: {
      let values: [Pack2<Int, Int>] = .stdin(rows: 2)
      XCTAssertEqual(values, [Pack2(1, 2), Pack2(3, 4)])
    })
    .inputOnly("1 2\n3 4")
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

  // 1文字は直後の1バイトを区切りとして受け取るので、詰めて書かれた文字も失わない
  func testPackAdjacentCharacters() throws {
    if #available(macOS 14.0, *) {
      try SolverRunner(solver: {
        let A: Pack<Character, Character> = .stdin
        XCTAssertEqual(A.rawValue.0, "a")
        XCTAssertEqual(A.rawValue.1, "b")
      })
      .inputOnly("ab")
    }
  }

  // UInt8 は数値ではなく1バイトとして読む
  func testTupleUInt8IsByte() throws {
    try SolverRunner(solver: {
      let (a, b): (UInt8, Int) = stdin()
      XCTAssertEqual(a, UInt8(ascii: "7"))
      XCTAssertEqual(b, 12)
    })
    .inputOnly("7 12")
  }

  // 入力の最後が1文字のとき、先読みは入力の終わり（nil）になる
  func testPackCharacterAtEOF() throws {
    if #available(macOS 14.0, *) {
      try SolverRunner(solver: {
        let A: Pack<Int, Character> = .stdin
        XCTAssertEqual(A.rawValue.0, 1)
        XCTAssertEqual(A.rawValue.1, "a")
      })
      .inputOnly("1 a")
    }
  }

  func testTupleCharacterAtEOF() throws {
    try SolverRunner(solver: {
      let (a, b): (Int, Character) = stdin()
      XCTAssertEqual(a, 1)
      XCTAssertEqual(b, "a")
    })
    .inputOnly("1 a")
  }

  // 1文字のあとも次の行を読める（先読みした改行は押し戻される）
  func testPackCharacterThenNextLine() throws {
    if #available(macOS 14.0, *) {
      try SolverRunner(solver: {
        let A: Pack<Int, Character> = .stdin
        XCTAssertEqual(A.rawValue.1, "a")
        XCTAssertEqual(Int.stdin, 2)
      })
      .inputOnly("1 a\n2")
    }
  }
}
