import XCTest
import CharacterUtil

final class CharacterSequenceComparisonTests: XCTestCase {

  func testLessThan() {
    XCTAssertTrue(Array("abc") < Array("abd"))       // abc < abd
    XCTAssertTrue(Array("a") < Array("abc"))          // a < abc
    XCTAssertFalse(Array("abc") < Array("abc"))       // abc ≮ abc
    XCTAssertFalse(Array("abd") < Array("abc"))       // abd ≮ abc
  }

  func testEqualTo() {
    XCTAssertTrue(Array("abc") == Array("abc"))       // abc == abc
    XCTAssertFalse(Array("abc") == Array("abd"))      // abc ≠ abd
    XCTAssertFalse(Array("abc") == Array("ab"))       // abc ≠ ab
  }

  func testGreaterThan() {
    XCTAssertTrue(Array("abd") > Array("abc"))        // abd > abc
    XCTAssertTrue(Array("abc") > Array("a"))          // abc > a
    XCTAssertFalse(Array("abc") > Array("abc"))       // abc ≯ abc
    XCTAssertFalse(Array("abc") > Array("abd"))       // abc ≯ abd
  }

  func testLessThanOrEqualTo() {
    XCTAssertTrue(Array("abc") <= Array("abc"))       // abc ≤ abc
    XCTAssertTrue(Array("abc") <= Array("abd"))       // abc ≤ abd
    XCTAssertFalse(Array("abd") <= Array("abc"))      // abd ≰ abc
  }

  func testGreaterThanOrEqualTo() {
    XCTAssertTrue(Array("abc") >= Array("abc"))       // abc ≥ abc
    XCTAssertTrue(Array("abd") >= Array("abc"))       // abd ≥ abc
    XCTAssertFalse(Array("abc") >= Array("abd"))      // abc ≱ abd
  }

  func testMixedSequenceTypesConvertedToCharacterArray() {
    let lhs: [Character] = Array("abc")
    let rhs: [Character] = Array("abc"[...]) // Substring → [Character]

    XCTAssertTrue(lhs == rhs)
    XCTAssertFalse(lhs < rhs)
    XCTAssertTrue(lhs <= rhs)
    XCTAssertTrue(lhs >= rhs)
  }
}

import XCTest

final class CharacterStrideableTests: XCTestCase {

  func testDistanceBetweenASCIICharacters() {
    XCTAssertEqual(Character("a").distance(to: "a"), 0)
    XCTAssertEqual(Character("a").distance(to: "c"), 2)
    XCTAssertEqual(Character("d").distance(to: "a"), -3)
    XCTAssertEqual(Character("z").distance(to: "a"), -25)
    XCTAssertEqual(Character("A").distance(to: "Z"), 25)
  }

  func testAdvanceByASCII() {
    XCTAssertEqual(Character("a").advanced(by: 0), "a")
    XCTAssertEqual(Character("a").advanced(by: 2), "c")
    XCTAssertEqual(Character("z").advanced(by: -25), "a")
    XCTAssertEqual(Character("Z").advanced(by: -25), "A")
  }

  func testStrideUsage() {
    let str = String(stride(from: "a", through: "e", by: 1))
    XCTAssertEqual(str, "abcde")

    let reversed = String(stride(from: "e", through: "a", by: -1))
    XCTAssertEqual(reversed, "edcba")
  }

//  func testNonASCIICharactersCrashOnDistance() {
//    let emoji1 = Character("😀")
//    let emoji2 = Character("😃")
//    expectFatalError {
//      _ = emoji1.distance(to: emoji2)
//    }
//  }
//
//  func testNonASCIICharacterCrashOnAdvance() {
//    let emoji = Character("😀")
//    expectFatalError {
//      _ = emoji.advanced(by: 1)
//    }
//  }
}
