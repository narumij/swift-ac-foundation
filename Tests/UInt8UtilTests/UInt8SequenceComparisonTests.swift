import XCTest
import UInt8Util

final class UInt8SequenceComparisonTests: XCTestCase {
  
  func uint8seq(_ str: String) -> [UInt8] {
    str.compactMap(\.asciiValue)
  }

  func testLessThan() {
    XCTAssertTrue(uint8seq("abc") < uint8seq("abd"))       // abc < abd
    XCTAssertTrue(uint8seq("a") < uint8seq("abc"))          // a < abc
    XCTAssertFalse(uint8seq("abc") < uint8seq("abc"))       // abc ≮ abc
    XCTAssertFalse(uint8seq("abd") < uint8seq("abc"))       // abd ≮ abc
  }

  func testEqualTo() {
    XCTAssertTrue(uint8seq("abc") == uint8seq("abc"))       // abc == abc
    XCTAssertFalse(uint8seq("abc") == uint8seq("abd"))      // abc ≠ abd
    XCTAssertFalse(uint8seq("abc") == uint8seq("ab"))       // abc ≠ ab
  }

  func testGreaterThan() {
    XCTAssertTrue(uint8seq("abd") > uint8seq("abc"))        // abd > abc
    XCTAssertTrue(uint8seq("abc") > uint8seq("a"))          // abc > a
    XCTAssertFalse(uint8seq("abc") > uint8seq("abc"))       // abc ≯ abc
    XCTAssertFalse(uint8seq("abc") > uint8seq("abd"))       // abc ≯ abd
  }

  func testLessThanOrEqualTo() {
    XCTAssertTrue(uint8seq("abc") <= uint8seq("abc"))       // abc ≤ abc
    XCTAssertTrue(uint8seq("abc") <= uint8seq("abd"))       // abc ≤ abd
    XCTAssertFalse(uint8seq("abd") <= uint8seq("abc"))      // abd ≰ abc
  }

  func testGreaterThanOrEqualTo() {
    XCTAssertTrue(uint8seq("abc") >= uint8seq("abc"))       // abc ≥ abc
    XCTAssertTrue(uint8seq("abd") >= uint8seq("abc"))       // abd ≥ abc
    XCTAssertFalse(uint8seq("abc") >= uint8seq("abd"))      // abc ≱ abd
  }

  func testMixedSequenceTypesConvertedToCharacterArray() {
    let lhs: [UInt8] = uint8seq("abc")
    let rhs: ArraySlice<UInt8> = uint8seq("abc")[...] // Substring → [Character]

    XCTAssertTrue(lhs == rhs)
    XCTAssertFalse(lhs < rhs)
    XCTAssertTrue(lhs <= rhs)
    XCTAssertTrue(lhs >= rhs)
  }
}
