import IOUtil
import TestingUtil
import XCTest

final class DigitPrintTests: XCTestCase {

  func testSwiftTwoDigitImplementation() throws {
    let signedValues = [
      Int.min, -10_001, -10_000, -9_999, -101, -100, -99, -10, -9, 0,
      9, 10, 99, 100, 101, 9_999, 10_000, 10_001, Int.max
    ]
    let unsignedValues = [
      UInt.min, 9, 10, 99, 100, 101, 9_999, 10_000, 10_001, UInt.max
    ]
    let expected = (signedValues.map(String.init) + unsignedValues.map(String.init)).joined(separator: "\n")

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___printIntTwo($0); print() }
        unsignedValues.forEach { ___printUIntTwo($0); print() }
      }).run(input: ""),
      expected
    )
  }

  func testSwiftEightDigitImplementation() throws {
    let signedValues = [
      Int.min, -100_000_001, -100_000_000, -99_999_999, -10_000_001, -10_000_000,
      -9_999_999, -1_000_001, -1_000_000, -999_999, -100_001, -100_000,
      -99_999, -10_001, -10_000, -9_999, -1_001, -1_000, -999, -101,
      -100, -99, -10, -9, 0, 9, 10, 99, 100, 999, 1_000, 9_999,
      10_000, 99_999, 100_000, 999_999, 1_000_000, 9_999_999,
      10_000_000, 99_999_999, 100_000_000, 100_000_001, Int.max
    ]
    let unsignedValues = [
      UInt.min, 9, 10, 99, 100, 999, 1_000, 9_999, 10_000, 99_999,
      100_000, 999_999, 1_000_000, 9_999_999, 10_000_000, 99_999_999,
      100_000_000, 100_000_001, UInt.max
    ]
    let expected = (signedValues.map(String.init) + unsignedValues.map(String.init)).joined(separator: "\n")

    XCTAssertEqual(
      try SolverRunner(solver: {
        signedValues.forEach { ___printIntEight($0); print() }
        unsignedValues.forEach { ___printUIntEight($0); print() }
      }).run(input: ""),
      expected
    )
  }
}
