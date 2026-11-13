import IOBase
import XCTest

// 本番と同じく、押し戻しの置き場所を使う設定でテストする。
// テストのあとは元の設定に戻す。
class IOReaderV2TestCase: XCTestCase {
  private var savedConfiguration = InputConfiguration.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    savedConfiguration = InputConfiguration.shared
    InputConfiguration.shared.usesPendingCharacter = true
  }

  override func tearDownWithError() throws {
    InputConfiguration.shared = savedConfiguration
    try super.tearDownWithError()
  }
}
