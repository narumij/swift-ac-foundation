import IOUtil
import TestingUtil
import UInt8Util
import XCTest

final class UInt8ExtensionsTests: XCTestCase {

  func testLowercaseAndUppercaseProperties() {
    let lowerA = Character("a").asciiValue!
    let lowerZ = Character("z").asciiValue!
    let upperA = Character("A").asciiValue!
    let upperZ = Character("Z").asciiValue!
    let beforeUpperA: UInt8 = 0x40  // '@'
    let afterUpperZ: UInt8 = 0x5B  // '['
    let beforeLowerA: UInt8 = 0x60  // '`'
    let afterLowerZ: UInt8 = 0x7B  // '{'

    XCTAssertTrue(lowerA.isLowercase)
    XCTAssertTrue(lowerZ.isLowercase)
    XCTAssertFalse(upperA.isLowercase)
    XCTAssertFalse(beforeLowerA.isLowercase)
    XCTAssertFalse(afterLowerZ.isLowercase)

    XCTAssertTrue(upperA.isUppercase)
    XCTAssertTrue(upperZ.isUppercase)
    XCTAssertFalse(lowerA.isUppercase)
    XCTAssertFalse(beforeUpperA.isUppercase)
    XCTAssertFalse(afterUpperZ.isUppercase)
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
    let beforeZero: UInt8 = 0x2F  // '/'
    let zero: UInt8 = "0"
    let seven = Character("7").asciiValue!
    let nine = Character("9").asciiValue!
    let afterNine: UInt8 = 0x3A  // ':'
    let letterA = Character("A").asciiValue!

    XCTAssertNil(beforeZero.wholeNumberValue)
    XCTAssertEqual(zero.wholeNumberValue, 0)
    XCTAssertEqual(seven.wholeNumberValue, 7)
    XCTAssertEqual(nine.wholeNumberValue, 9)
    XCTAssertNil(afterNine.wholeNumberValue)
    XCTAssertNil(letterA.wholeNumberValue)

    XCTAssertFalse(beforeZero.isWholeNumber)
    XCTAssertTrue(zero.isWholeNumber)
    XCTAssertTrue(nine.isWholeNumber)
    XCTAssertFalse(afterNine.isWholeNumber)
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

    let beforeZero: UInt8 = 0x2F  // '/'
    let afterNine: UInt8 = 0x3A  // ':'
    let beforeUpperA: UInt8 = 0x40  // '@'
    let afterUpperF = Character("G").asciiValue!
    let beforeLowerA: UInt8 = 0x60  // '`'
    let afterLowerF = Character("g").asciiValue!

    XCTAssertNil(beforeZero.hexDigitValue)
    XCTAssertNil(afterNine.hexDigitValue)
    XCTAssertNil(beforeUpperA.hexDigitValue)
    XCTAssertNil(afterUpperF.hexDigitValue)
    XCTAssertNil(beforeLowerA.hexDigitValue)
    XCTAssertNil(afterLowerF.hexDigitValue)
    XCTAssertFalse(beforeZero.isHexDigit)
    XCTAssertFalse(afterNine.isHexDigit)
    XCTAssertFalse(beforeUpperA.isHexDigit)
    XCTAssertFalse(afterUpperF.isHexDigit)
    XCTAssertFalse(beforeLowerA.isHexDigit)
    XCTAssertFalse(afterLowerF.isHexDigit)
  }
}

final class StringAsciiExtensionsTests: XCTestCase {

  func testInitAsciiValuesWithArray() {
    let bytes: [UInt8] = [0x41, 0x42, 0x43]  // "A", "B", "C"
    let s = String(asciiValues: bytes)
    XCTAssertEqual(s, "ABC")
  }

  func testInitAsciiValuesWithDataSequence() {
    let data = Data([0x68, 0x69, 0x21])  // "h", "i", "!"
    let s = String(asciiValues: data)
    XCTAssertEqual(s, "hi!")
  }

  func testInitAsciiValuesEmptySequence() {
    let empty: [UInt8] = []
    let s = String(asciiValues: empty)
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

  func test_readLineStripsCRLF() throws {
    try SolverRunner(solver: {
      let line: [UInt8] = readLine()!
      XCTAssertEqual(line, Array("abc".utf8))
    }).inputOnly("abc\r\nnext")
  }
}

#if false
  func __readLine_stdin(_ p: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>) -> Int {
    var capacity = 0
    var result = 0
    repeat {
      result = getline(p, &capacity, stdin)
    } while result < 0 && errno == EINTR
    return result
  }

  public func __readLine<T>(_ f: (UnsafePointer<CChar>, Int) throws -> T) throws -> T {
    var utf8Start: UnsafeMutablePointer<CChar>?
    let utf8Count = __readLine_stdin(&utf8Start)
    defer {
      _free(utf8Start)
    }
    guard utf8Count > 0, let utf8Start else {
      throw UInt8UtilError.unexpectedEOF
    }
    return try f(utf8Start, utf8Count)
  }

  public func __readLine(strippingNewline: Bool = true) -> [UInt8]? {
    try? __readLine { start, count in
      [UInt8].init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
        for i in 0..<count {
          (buffer.baseAddress! + i).initialize(to: UInt8(start[i]))
        }
        initializedCount = count
        if strippingNewline, start[count - 1] == 0x0A {
          initializedCount -= 1
        }
      }
    }
  }
#endif
