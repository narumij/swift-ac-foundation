import XCTest
import IOBase

class IOReaderV2ExtraTestCase: XCTestCase {
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
