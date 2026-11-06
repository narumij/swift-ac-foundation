import XCTest
import IOReader

class IOReaderTests: XCTestCase {
  private var savedConfiguration = InputConfiguration.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    savedConfiguration = InputConfiguration.shared
  }

  override func tearDownWithError() throws {
    InputConfiguration.shared.usesPendingCharacter = false
    InputConfiguration.shared = savedConfiguration
    try super.tearDownWithError()
  }
}
