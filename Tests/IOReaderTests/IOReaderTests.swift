import XCTest
import _FastIO

class IOReaderTests: XCTestCase {
  
  override func setUpWithError() throws {
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    _restore_stdin()
    try super.tearDownWithError()
  }
}
