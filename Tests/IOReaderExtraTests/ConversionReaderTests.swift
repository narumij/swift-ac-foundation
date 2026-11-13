import AtCoder
import BigInt
import IOReader
import IOReaderExtra
import TestingUtil
import XCTest

// IOReaderExtraTests の BigInt・modint のテストを V2 で移したもの。後半は並びの読み取りの確認。
final class ConversionReaderTests: IOReaderExtraTestCase {

  func testModint() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(modint998244353.stdin, 0)
      XCTAssertEqual(modint998244353.stdin, 3)
      XCTAssertEqual(modint998244353.stdin.val, modint998244353.mod - 1)
      XCTAssertEqual(modint998244353.stdin.val, modint998244353.mod - 1)
      XCTAssertEqual(modint998244353.stdin.val, 0)
    })
    .inputOnly(
      """
      0
      3
      -1
      \(modint998244353.mod - 1)
      \(modint998244353.mod)
      """)
  }

  func testBigInt() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(BigInt.stdin, 3)
      XCTAssertEqual(BigInt.stdin, -1)
    })
    .inputOnly("3\n-1")
  }

  @available(macOS 15.0, *)
  func testBigIntBeyondInt64() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(BigInt.stdin)
        print(BigInt.stdin)
        print(BigInt.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          \(Int128.min)
          \(UInt128.max)
          """),
      """
      \(Int128.max)
      \(Int128.min)
      \(UInt128.max)
      """)
  }

  func testBigIntLine() throws {
    try SolverRunner(solver: {
      let A: [BigInt] = .stdin()
      let B: [BigInt] = .stdin()
      XCTAssertEqual(A, [1, 2, 3])
      XCTAssertEqual(B, [4])
    })
    .inputOnly("1 2 3\n4")
  }

  func testModintColumnsAndRows() throws {
    try SolverRunner(solver: {
      let A: [modint998244353] = .stdin(columns: 3)
      let B: [[modint998244353]] = .stdin(rows: 2, columns: 2)
      XCTAssertEqual(A, [1, 2, 3])
      XCTAssertEqual(B, [[4, 5], [6, 7]])
    })
    .inputOnly("1 2 3\n4 5\n6 7")
  }
}
