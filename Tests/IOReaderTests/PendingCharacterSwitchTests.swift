import IOBase
import IOReader
import IOReaderExtra
import Pack
import TestingUtil
import XCTest

// 押し戻しの置き場所を使う設定から使わない設定へ切り替えても、保留中の1バイトが標準入力へ戻り、
// そのあとの読み取り（Swift の readLine を含む）を乱さないことを、読み取りの種類ごとに確かめる。
final class PendingCharacterSwitchTests: IOReaderTestCase {

  // 置き場所ありで read を実行し、置き場所なしに切り替えたあと、残りの1行が rest になることを確かめる。
  private func assertSwitch(
    _ input: String, rest: String, file: StaticString = #filePath, line: UInt = #line,
    _ read: @escaping () -> Void
  ) throws {
    try SolverRunner(solver: {
      InputConfiguration.shared.usesPendingCharacter = true
      read()
      InputConfiguration.shared.usesPendingCharacter = false
      XCTAssertEqual(String.readLine(), rest, file: file, line: line)
    }).inputOnly(input)
  }

  // 単発の読み取り：直後の区切りが押し戻されている
  func testSingleReads() throws {
    if #available(macOS 15.0, *) {
      try assertSwitch("12 rest\n", rest: " rest") { XCTAssertEqual(Int128.stdin, 12) }
      try assertSwitch("12 rest\n", rest: " rest") { XCTAssertEqual(UInt128.stdin, 12) }
    }
    try assertSwitch("12 rest\n", rest: " rest") { XCTAssertEqual(Int.stdin, 12) }
    try assertSwitch("12 rest\n", rest: " rest") { XCTAssertEqual(UInt.stdin, 12) }
    try assertSwitch("1.5 rest\n", rest: " rest") { XCTAssertEqual(Double.stdin, 1.5) }
    try assertSwitch("1 2 rest\n", rest: " rest") { XCTAssertEqual(SIMD2<Int>.stdin, SIMD2(1, 2)) }
    try assertSwitch("ab rest\n", rest: " rest") { XCTAssertEqual(String.stdin, "ab") }
    try assertSwitch("ab rest\n", rest: " rest") { XCTAssertEqual([Character].stdin, ["a", "b"]) }
    try assertSwitch("ab rest\n", rest: " rest") { XCTAssertEqual([UInt8].stdin, Array("ab".utf8)) }
    try assertSwitch("ab\n", rest: "b") { XCTAssertEqual(Character.stdin, "a") }
    try assertSwitch("ab\n", rest: "b") { XCTAssertEqual(UInt8.stdin, UInt8(ascii: "a")) }
  }

  // 組の読み取り：最後の要素の区切りが押し戻されている
  func testGroupReads() throws {
    try assertSwitch("1 x rest\n", rest: " rest") {
      let (a, b): (Int, Character) = stdin()
      XCTAssertEqual(a, 1)
      XCTAssertEqual(b, "x")
    }
    try assertSwitch("1 2 3 rest\n", rest: " rest") {
      let (a, b): (Int, SIMD2<Int>) = stdin()
      XCTAssertEqual(a, 1)
      XCTAssertEqual(b, SIMD2(2, 3))
    }
    if #available(macOS 14.0, *) {
      try assertSwitch("1 x rest\n", rest: " rest") {
        let p: Pack<Int, Character> = .stdin
        XCTAssertEqual(p.rawValue.0, 1)
        XCTAssertEqual(p.rawValue.1, "x")
      }
    }
  }

  // 行で止まる読み取り：行末の改行は消費済みで、次の行がそのまま残る
  func testLineReads() throws {
    try assertSwitch("1 2\nnext\n", rest: "next") { XCTAssertEqual([Int].stdin(), [1, 2]) }
    try assertSwitch("1 2\nnext\n", rest: "next") { XCTAssertEqual([Int32].stdin(), [1, 2]) }
    try assertSwitch("a b\nnext\n", rest: "next") { XCTAssertEqual([String].stdin(), ["a", "b"]) }
    try assertSwitch("1 2\nnext\n", rest: "next") { XCTAssertEqual([Int].stdin(columns: 2), [1, 2]) }
    try assertSwitch("1 2\nnext\n", rest: "next") { XCTAssertEqual([Int32].stdin(columns: 2), [1, 2]) }
    try assertSwitch("a b\nnext\n", rest: "next") { XCTAssertEqual([String].stdin(columns: 2), ["a", "b"]) }
    try assertSwitch("1\n2\nnext\n", rest: "next") { XCTAssertEqual([Int].stdin(rows: 2), [1, 2]) }
    try assertSwitch("1\n2\nnext\n", rest: "next") { XCTAssertEqual([Int32].stdin(rows: 2), [1, 2]) }
    try assertSwitch("1 2\nnext\n", rest: "next") {
      XCTAssertEqual([[Int]].stdin(rows: 1, columns: 2), [[1, 2]])
    }
    try assertSwitch("1 2\nnext\n", rest: "next") {
      XCTAssertEqual([SIMD2<Int>].stdin(rows: 1), [SIMD2(1, 2)])
    }
    if #available(macOS 26.0, *) {
      try assertSwitch("1 2\nnext\n", rest: "next") {
        let a: InlineArray<2, Int> = .stdin
        XCTAssertEqual([a[0], a[1]], [1, 2])
      }
    }
    try assertSwitch("a b\nc\nnext\n", rest: "next") {
      XCTAssertEqual([String].stdin(rows: 2), ["a b", "c"])
    }
  }

  // 文字数を指定した読み取り：指定した文字数だけ読み、先は読まない
  func testCountedReads() throws {
    try assertSwitch("abc\n", rest: "c") { XCTAssertEqual([Character].stdin(columns: 2), ["a", "b"]) }
    try assertSwitch("abc\n", rest: "c") { XCTAssertEqual([UInt8].stdin(columns: 2), Array("ab".utf8)) }
    try assertSwitch("abc\n", rest: "c") { XCTAssertEqual(String.stdin(columns: 2), "ab") }
  }

  // 切り替えずに置き場所ありのまま readLine しても、押し戻した1バイトを失わない
  func testReadLineWithoutSwitch() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, 12)
      XCTAssertEqual(String.readLine(), " rest")
      XCTAssertEqual(Int.stdin, 34)
      XCTAssertEqual(String.readLine(), "next")
    }).inputOnly("12 rest\n34\nnext\n")
  }
}
