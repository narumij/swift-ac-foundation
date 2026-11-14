import IOUtil
import TestingUtil
import UInt8Util
import XCTest

final class UInt8ReadLineTests: XCTestCase {

  func testputchars_unlocked() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        "ABC".asciiValues.putchars_unlocked()
        "DE".asciiValues.putchars_unlocked(terminator: 0x20)
        "F".asciiValues.putchars_unlocked()
      })
      .run(
        input:
          """
          """),

      """
      ABC
      DE F
      """)
  }

  func test_readLine0() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [UInt8] = readLine()!
        print(String(bytes: SS, encoding: .ascii)!)
        print("DUMMY")
      })
      .run(
        input:
          """
          aaaaaaaaaaaaabb
          cc
          """),

      """
      aaaaaaaaaaaaabb
      DUMMY
      """)
  }

  func test_readLine1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [UInt8] = readLine(strippingNewline: false)!
        print(String(bytes: SS, encoding: .ascii)!)
        print("DUMMY")
      })
      .run(
        input:
          """
          aaaaaaaaaaaaabb
          cc
          """),

      """
      aaaaaaaaaaaaabb

      DUMMY
      """)
  }

  func test_readLineStripsCRLF() throws {
    try SolverRunner(solver: {
      let line: [UInt8] = readLine()!
      XCTAssertEqual(line, Array("abc".utf8))
    }).inputOnly("abc\r\nnext")
  }
}
