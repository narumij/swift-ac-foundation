import TestingUtil
import XCTest

#if DEBUG
  @testable import IOUtil
#else
  import IOUtil
#endif

final class ReadIntTests: XCTestCase {

  func testReadsSingleValues() throws {
    try assertReadInt(input: "0", expected: [0])
    try assertReadInt(input: "1", expected: [1])
    try assertReadInt(input: "-1", expected: [-1])
    try assertReadInt(input: "123456789", expected: [123_456_789])
    try assertReadInt(input: "-123456789", expected: [-123_456_789])
  }

  func testSkipsLeadingAsciiWhitespace() throws {
    try assertReadInt(input: "   42", expected: [42])
    try assertReadInt(input: "\t\t42", expected: [42])
    try assertReadInt(input: "\n\n42", expected: [42])
    try assertReadInt(input: "\r\r42", expected: [42])
    try assertReadInt(input: " \t\n\r42", expected: [42])
  }

  func testReadsWhitespaceSeparatedValues() throws {
    try assertReadInt(
      input: "1 2\t3\n4\r5  -6\t-7\n-8\r-9",
      expected: [1, 2, 3, 4, 5, -6, -7, -8, -9]
    )
  }

  func testReadsZerosAndSignedZeros() throws {
    try assertReadInt(
      input: "0 -0 00 000 -00 -000 000123 -000123",
      expected: [0, 0, 0, 0, 0, 0, 123, -123]
    )
  }

  func testReadsIntBounds() throws {
    try assertReadInt(
      input: "\(Int.max) \(Int.min)",
      expected: [Int.max, Int.min]
    )
  }

  func testReadsDigitWidthBoundaries() throws {
    let values = [
      -1_000_000_000, -100_000_000, -10_000_000, -1_000_000, -100_000, -10_000,
      -1_000, -100, -10, -9, -1, 0, 1, 9, 10, 99, 100, 999, 1_000, 9_999,
      10_000, 99_999, 100_000, 999_999, 1_000_000, 9_999_999, 10_000_000,
      99_999_999, 100_000_000, 999_999_999, 1_000_000_000,
    ]

    try assertReadInt(
      input: values.map(String.init).joined(separator: " "),
      expected: values
    )
  }

  func testReadsManySequentialValues() throws {
    let values = Array(-1_000...1_000)

    try assertReadInt(
      input: values.map(String.init).joined(separator: "\n"),
      expected: values
    )
  }

  func testReadsValuesWithTrailingWhitespace() throws {
    try assertReadInt(
      input: "10 20 30 \t\n\r   ",
      expected: [10, 20, 30]
    )
  }

  private func assertReadInt(
    input: String,
    expected: [Int],
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws {
    var actual: [Int] = []

    try SolverRunner {
      actual = expected.map { _ in simple_readInt() }
    }.inputOnly(input)

    XCTAssertEqual(actual, expected, file: file, line: line)
  }
}
