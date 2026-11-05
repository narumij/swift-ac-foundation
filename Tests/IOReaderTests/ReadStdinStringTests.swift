import IOReader
import TestingUtil
import XCTest

final class ReadStdinStringTests: IOReaderTests {

  func testStringStdinStaticProperty() throws {
    try SolverRunner(solver: {
      let A: String = .stdin
      let B: String = .stdin

      XCTAssertEqual(A, "Hello")
      XCTAssertEqual(B, "World")
    })
    .inputOnly(
      """
      Hello World
      """)
  }

  func testCharacterArrayStdinStaticProperty() throws {
    try SolverRunner(solver: {
      let A: [Character] = .stdin
      let B: [Character] = .stdin

      XCTAssertEqual(A, Array("Hello"))
      XCTAssertEqual(B, Array("World"))
    })
    .inputOnly(
      """
      Hello World
      """)
  }

  func testByteArrayStdinStaticProperty() throws {
    try SolverRunner(solver: {
      let A: [UInt8] = .stdin
      let B: [UInt8] = .stdin

      XCTAssertEqual(A, "Hello".asciiValues)
      XCTAssertEqual(B, "World".asciiValues)
    })
    .inputOnly(
      """
      Hello World
      """)
  }
}
