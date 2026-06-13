import IOReader
import Pack
import TestingUtil
import UInt8Util
import XCTest

final class ReaderTupleTests: XCTestCase {
  func testTuple1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let (A, B, C): (UInt8, [UInt8], Int) = try read()
        print(String(bytes: [A], encoding: .ascii)!)
        print(String(bytes: B, encoding: .ascii)!)
        print(C)
      })
      .run(
        input:
          """
          A BB 111
          """),

      """
      A
      BB
      111
      """)
  }

  func testUnwrap() throws {
    let a: Int? = 0
    XCTAssertNoThrow(try a.unwrap(or: IOReaderError.unexpectedNil))
    let b: Int? = nil
    XCTAssertThrowsError(try b.unwrap(or: IOReaderError.unexpectedNil)) {
      XCTAssertEqual($0 as? IOReaderError, IOReaderError.unexpectedNil)
    }
  }
}
