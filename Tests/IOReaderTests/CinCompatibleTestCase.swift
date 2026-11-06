import IOReader

class CinCompatibleTestCase: IOReaderTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    InputConfiguration.shared.usesPendingCharacter = false
  }
}
