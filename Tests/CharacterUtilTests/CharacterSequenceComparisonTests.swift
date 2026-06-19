import CharacterUtil
import XCTest

final class CharacterSequenceComparisonTests: XCTestCase {

  func testLessThan() {
    XCTAssertTrue(Array("abc") < Array("abd"))  // abc < abd
    XCTAssertTrue(Array("a") < Array("abc"))  // a < abc
    XCTAssertFalse(Array("abc") < Array("abc"))  // abc ≮ abc
    XCTAssertFalse(Array("abd") < Array("abc"))  // abd ≮ abc
  }

  func testEqualTo() {
    XCTAssertTrue(Array("abc") == Array("abc"))  // abc == abc
    XCTAssertFalse(Array("abc") == Array("abd"))  // abc ≠ abd
    XCTAssertFalse(Array("abc") == Array("ab"))  // abc ≠ ab
  }

  func testGreaterThan() {
    XCTAssertTrue(Array("abd") > Array("abc"))  // abd > abc
    XCTAssertTrue(Array("abc") > Array("a"))  // abc > a
    XCTAssertFalse(Array("abc") > Array("abc"))  // abc ≯ abc
    XCTAssertFalse(Array("abc") > Array("abd"))  // abc ≯ abd
  }

  func testLessThanOrEqualTo() {
    XCTAssertTrue(Array("abc") <= Array("abc"))  // abc ≤ abc
    XCTAssertTrue(Array("abc") <= Array("abd"))  // abc ≤ abd
    XCTAssertFalse(Array("abd") <= Array("abc"))  // abd ≰ abc
  }

  func testGreaterThanOrEqualTo() {
    XCTAssertTrue(Array("abc") >= Array("abc"))  // abc ≥ abc
    XCTAssertTrue(Array("abd") >= Array("abc"))  // abd ≥ abc
    XCTAssertFalse(Array("abc") >= Array("abd"))  // abc ≱ abd
  }

  func testMixedSequenceTypesConvertedToCharacterArray() {
    let lhs: [Character] = Array("abc")
    let rhs: [Character] = Array("abc"[...])  // Substring → [Character]

    XCTAssertTrue(lhs == rhs)
    XCTAssertFalse(lhs < rhs)
    XCTAssertTrue(lhs <= rhs)
    XCTAssertTrue(lhs >= rhs)
  }
}
