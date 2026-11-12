import IOBase

class CinCompatibleV2TestCase: IOBaseTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    InputConfiguration.shared.usesPendingCharacter = false
  }
}
