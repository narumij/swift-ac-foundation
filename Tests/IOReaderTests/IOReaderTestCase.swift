import IOBase
import XCTest
@preconcurrency import _FastIO

// 本番と同じく、押し戻しの置き場所を使う設定でテストする。
// テストのあとは元の設定に戻す。
class IOReaderTestCase: XCTestCase {
  private var savedConfiguration = InputConfiguration.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    savedConfiguration = InputConfiguration.shared
    InputConfiguration.shared.usesPendingCharacter = true
  }

  // 置き場所に残った1バイトはこのテストの入力のもの。捨ててから設定を戻し、次のテストの stdin へ漏らさない。
  override func tearDownWithError() throws {
    _fastio_pending_character = EOF
    InputConfiguration.shared = savedConfiguration
    try super.tearDownWithError()
  }
}
