import XCTest
import IOReader

class IOReaderTests: XCTestCase {
  
  override func setUpWithError() throws {
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    InputConfiguration.shared.usesPendingCharacter = false
    try super.tearDownWithError()
  }
}
