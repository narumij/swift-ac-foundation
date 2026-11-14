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

  func testSubstringIntSubscript() throws {
    // 先頭からずれた Substring でも、添字は Substring の先頭を 0 として数える
    let sub = "abcdef".dropFirst(2)
    XCTAssertEqual("cdef", sub)
    XCTAssertEqual("c", sub[0])
    XCTAssertEqual("f", sub[3])
    XCTAssertEqual(Array(sub), (0..<sub.count).map { sub[$0] })
    XCTAssertEqual("de", sub[1..<3])
    XCTAssertEqual("cdef", sub[0...])
    XCTAssertEqual("cde", sub[...2])
    XCTAssertEqual("", sub[2..<2])
  }

  func testSubstringUnicode() throws {
    let sub = "xaé👍b".dropFirst()
    XCTAssertEqual("a", sub[0])
    XCTAssertEqual("é", sub[1])
    XCTAssertEqual("👍", sub[2])
    XCTAssertEqual("é👍", sub[1..<3])
  }
}
