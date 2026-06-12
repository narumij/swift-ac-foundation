import TestingUtil
import XCTest

final class StringComparisonTests: XCTestCase {

  func str(_ str: String) -> String {
    str
  }

  func testLessThan() {
    XCTAssertTrue(str("abc") < str("abd"))  // abc < abd
    XCTAssertTrue(str("a") < str("abc"))  // a < abc
    XCTAssertFalse(str("abc") < str("abc"))  // abc ≮ abc
    XCTAssertFalse(str("abd") < str("abc"))  // abd ≮ abc
  }

  func testEqualTo() {
    XCTAssertTrue(str("abc") == str("abc"))  // abc == abc
    XCTAssertFalse(str("abc") == str("abd"))  // abc ≠ abd
    XCTAssertFalse(str("abc") == str("ab"))  // abc ≠ ab
  }

  func testGreaterThan() {
    XCTAssertTrue(str("abd") > str("abc"))  // abd > abc
    XCTAssertTrue(str("abc") > str("a"))  // abc > a
    XCTAssertFalse(str("abc") > str("abc"))  // abc ≯ abc
    XCTAssertFalse(str("abc") > str("abd"))  // abc ≯ abd
  }

  func testLessThanOrEqualTo() {
    XCTAssertTrue(str("abc") <= str("abc"))  // abc ≤ abc
    XCTAssertTrue(str("abc") <= str("abd"))  // abc ≤ abd
    XCTAssertFalse(str("abd") <= str("abc"))  // abd ≰ abc
  }

  func testGreaterThanOrEqualTo() {
    XCTAssertTrue(str("abc") >= str("abc"))  // abc ≥ abc
    XCTAssertTrue(str("abd") >= str("abc"))  // abd ≥ abc
    XCTAssertFalse(str("abc") >= str("abd"))  // abc ≱ abd
  }
}
