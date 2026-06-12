import XCTest
import StringUtil

final class SubStringTests: XCTestCase {

  func testSubstring() throws {
    let s = "abcdef"
    XCTAssertEqual(s, s[0..<s.count])
    XCTAssertEqual("abcdef", s[0..<s.count])
    XCTAssertEqual("abcdef", s[0...])
    XCTAssertEqual("abcdef", s[..<s.count])
    XCTAssertEqual("cd", s[2..<4])
    XCTAssertEqual("cdef", s[2...])
    XCTAssertEqual("abcd", s[..<4])
    XCTAssertEqual("abcde", s[...4])

    XCTAssertEqual("a", s[0])
    XCTAssertEqual(Array(s), (0..<s.count).map { s[$0] })

    XCTAssertEqual("ABCDEF", s.uppercased())

    print(s[0...])
  }
}
