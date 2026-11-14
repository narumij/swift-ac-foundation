import XCTest
import IOBase

class IOBaseTestCase: XCTestCase {
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
