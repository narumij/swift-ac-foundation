import IOBase
import XCTest

// テストのあいだで押し戻しの1バイトが持ち越されないよう、テスト中は押し戻しの置き場所を使わない。
// IOBaseTests の CinCompatibleV2TestCase と同じ形。
class IOReaderV2TestCase: XCTestCase {
  private var savedConfiguration = InputConfiguration.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    savedConfiguration = InputConfiguration.shared
    InputConfiguration.shared.usesPendingCharacter = false
  }

  override func tearDownWithError() throws {
    InputConfiguration.shared = savedConfiguration
    try super.tearDownWithError()
  }
}
