import IOUtil
import TestingUtil
import XCTest

final class IOUtilCRLFTests: XCTestCase {

  func testReadIntLineTreatsCRLFAsLineEnding() throws {
    // 修正前は `\r` を行末として扱わず、数字の一部として parse していた。
    // そのため `2\r\n` の `\r` から不正な digit 値を作り、`[-1, 0, -15]` に
    // なってこのテストが赤になった。修正では、外側の loop と parser の両方で
    // CR を LF と同じ行末区切りとして扱うようにした。
    try SolverRunner {
      let first: [Int] = readIntLine()
      let second: [Int] = readIntLine()
      XCTAssertEqual(first, [-1, 0, 2])
      XCTAssertEqual(second, [3, 4])
    }.inputOnly("-1 0 2\r\n3 4")
  }

  func testReadUIntLineTreatsCRLFAsLineEnding() throws {
    // UInt でも同じ問題があり、修正前は `2\r\n` の `\r` を digit 扱いして
    // `[1, 0, 18446744073709551601]` になって赤になった。期待する動作は、
    // CRLF を行末として扱い、次の `3 4` は次行として読むこと。
    try SolverRunner {
      let first: [UInt] = readUIntLine()
      let second: [UInt] = readUIntLine()
      XCTAssertEqual(first, [1, 0, 2])
      XCTAssertEqual(second, [3, 4])
    }.inputOnly("1 0 2\r\n3 4")
  }
}
