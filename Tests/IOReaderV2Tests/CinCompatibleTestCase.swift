import IOReaderV2

class CinCompatibleV2TestCase: IOReaderV2TestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    InputConfiguration.shared.usesPendingCharacter = false
  }
}
