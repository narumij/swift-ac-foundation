import IOBase
import IOReaderV2
import TestingUtil
import XCTest

// 押し戻しの置き場所を使う設定から使わない設定へ切り替えても、保留中の1バイトが標準入力へ戻り、
// そのあとの読み取り（Swift の readLine を含む）を乱さないことを確かめる。
final class PendingCharacterSwitchTests: IOReaderV2TestCase {

  func testSwitchAfterSingleRead() throws {
    try SolverRunner(solver: {
      XCTAssertEqual(Int.stdin, 12)
      InputConfiguration.shared.usesPendingCharacter = false
      XCTAssertEqual(String.readLine(), " rest")
      XCTAssertEqual(Int.stdin, 34)
    }).inputOnly("12 rest\n34\n")
  }

  func testSwitchAfterTupleRead() throws {
    try SolverRunner(solver: {
      let (a, b): (Int, Character) = stdin()
      XCTAssertEqual(a, 1)
      XCTAssertEqual(b, "x")
      InputConfiguration.shared.usesPendingCharacter = false
      XCTAssertEqual(String.readLine(), " rest")
      XCTAssertEqual([String].stdin(), ["a", "b"])
    }).inputOnly("1 x rest\na b\n")
  }
}
