import XCTest
import IOReaderV2

class IOReaderV2TestCase: XCTestCase {
  private var savedConfiguration = InputConfiguration.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    savedConfiguration = InputConfiguration.shared
  }

  override func tearDownWithError() throws {
    InputConfiguration.shared = savedConfiguration
    try super.tearDownWithError()
  }
}
