import IOStream

class CinCompatibleV2TestCase: IOStreamTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    InputConfiguration.shared.usesPendingCharacter = false
  }
}
