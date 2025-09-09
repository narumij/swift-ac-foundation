import UInt8Util
import XCTest

final class UInt8ExtensionsTests: XCTestCase {

  func testLowercaseAndUppercaseProperties() {
    let lowerA = Character("a").asciiValue!
    let upperA = Character("A").asciiValue!
    let midChar: UInt8 = 0x40  // '@'

    XCTAssertTrue(lowerA.isLowercase)
    XCTAssertFalse(upperA.isLowercase)
    XCTAssertFalse(midChar.isLowercase)

    XCTAssertTrue(upperA.isUppercase)
    XCTAssertFalse(lowerA.isUppercase)
    XCTAssertFalse(midChar.isUppercase)
  }

  func testLowercasedAndUppercasedMethods() {
    let lowerA = Character("a").asciiValue!
    let upperA = Character("A").asciiValue!
    let digit5 = Character("5").asciiValue!

    // lowercased()
    XCTAssertEqual(lowerA.lowercased(), lowerA)
    XCTAssertEqual(upperA.lowercased(), lowerA)
    XCTAssertEqual(digit5.lowercased(), digit5)

    // uppercased()
    XCTAssertEqual(upperA.uppercased(), upperA)
    XCTAssertEqual(lowerA.uppercased(), upperA)
    XCTAssertEqual(digit5.uppercased(), digit5)
  }

  func testWhitespaceAndNewlineProperties() {
    // isWhitespace
    XCTAssertTrue(UInt8(0x09).isWhitespace)  // HT
    XCTAssertTrue(UInt8(0x0A).isWhitespace)  // LF
    XCTAssertTrue(UInt8(0x0D).isWhitespace)  // CR
    XCTAssertTrue(UInt8(0x20).isWhitespace)  // Space
    XCTAssertTrue(UInt8(0x85).isWhitespace)  // NEL
    XCTAssertFalse(Character("A").asciiValue!.isWhitespace)

    // isNewline
    XCTAssertTrue(UInt8(0x0A).isNewline)  // LF
    XCTAssertTrue(UInt8(0x0D).isNewline)  // CR
    XCTAssertTrue(UInt8(0x85).isNewline)  // NEL
    XCTAssertFalse(UInt8(0x20).isNewline)  // Space
    XCTAssertFalse(Character("a").asciiValue!.isNewline)
  }

  func testWholeNumberProperties() {
    let zero: UInt8 = "0"
    let seven = Character("7").asciiValue!
    let nine = Character("9").asciiValue!
    let letterA = Character("A").asciiValue!

    XCTAssertEqual(zero.wholeNumberValue, 0)
    XCTAssertEqual(seven.wholeNumberValue, 7)
    XCTAssertEqual(nine.wholeNumberValue, 9)
    XCTAssertNil(letterA.wholeNumberValue)

    XCTAssertTrue(zero.isWholeNumber)
    XCTAssertTrue(nine.isWholeNumber)
    XCTAssertFalse(letterA.isWholeNumber)
  }

  func testHexDigitProperties() {
    let hexChars = Array("0123456789ABCDEFabcdef")
    let expectedValues = [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
      10, 11, 12, 13, 14, 15,
    ]

    for (ch, expected) in zip(hexChars, expectedValues) {
      let b = ch.asciiValue!
      XCTAssertEqual(b.hexDigitValue, expected, "`\(ch)` should be \(expected)")
      XCTAssertTrue(b.isHexDigit, "`\(ch)` should be recognized as hex digit")
    }

    // 非 16 進数文字
    let nonHex = Character("G").asciiValue!
    XCTAssertNil(nonHex.hexDigitValue)
    XCTAssertFalse(nonHex.isHexDigit)
  }
}

final class StringAsciiExtensionsTests: XCTestCase {

  func testInitAsciiWithArray() {
    let bytes: [UInt8] = [0x41, 0x42, 0x43]  // "A", "B", "C"
    let s = String(ascii: bytes)
    XCTAssertEqual(s, "ABC")
  }

  func testInitAsciiWithDataSequence() {
    let data = Data([0x68, 0x69, 0x21])  // "h", "i", "!"
    let s = String(ascii: data)
    XCTAssertEqual(s, "hi!")
  }

  func testInitAsciiEmptySequence() {
    let empty: [UInt8] = []
    let s = String(ascii: empty)
    XCTAssertEqual(s, "")
  }

  func testAsciiValues_AllASCII() {
    let s = "Hello, World!"
    let expected: [UInt8] = Array("Hello, World!".utf8)
    XCTAssertEqual(s.asciiValues, expected)
  }

  func testAsciiValues_SkipsNonASCII() {
    let s = "AéB👍C"
    // 'A' = 0x41, 'B' = 0x42, 'C' = 0x43; 'é' and '👍' are non-ASCII
    XCTAssertEqual(s.asciiValues, [0x41, 0x42, 0x43])
  }

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
}
