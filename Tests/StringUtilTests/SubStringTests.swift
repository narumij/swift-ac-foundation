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

  func testEmptyRanges() throws {
    let s = "abcdef"
    XCTAssertEqual("", s[2..<2])
    XCTAssertEqual("", s[..<0])
    XCTAssertEqual("", s[s.count...])
  }

  func testUnicodeCharacterIndexingAndSlicing() throws {
    let s = "aé👍b"
    XCTAssertEqual(s.count, 4)
    XCTAssertEqual("a", s[0])
    XCTAssertEqual("é", s[1])
    XCTAssertEqual("👍", s[2])
    XCTAssertEqual("b", s[3])
    XCTAssertEqual("é👍", s[1..<3])
  }
}
