import BigInt
import XCTest

#if DEBUG
  @testable import AcFoundation
#else
  import AcFoundation
#endif

#if false
//extension UInt: IOReadableInteger { }

extension UInt: IOStringConversionReadable {
  @inlinable @inline(__always)
  static public func convert(from: String) -> UInt { .init(from)! }
}

extension Int128: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}

extension UInt128: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}

extension BigInt: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}

//extension BigInt: IOIntegerConversionReadable {
//  @inlinable @inline(__always)
//  public static func convert(from: Int) -> Self { .init(from) }
//}

final class ConversionReadableTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testUInt() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt.stdin)
      })
      .run(
        input:
          """
          \(UInt.max)
          """),
      """
      \(UInt.max)
      """)
  }

  func testInt128() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        print(Int128.stdin)
        print(Int128.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          \(Int128.min)
          """),
      """
      \(Int128.max)
      \(Int128.min)
      """)
  }

  func testUInt128() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        print(UInt128.stdin)
      })
      .run(
        input:
          """
          \(UInt128.max)
          """),
      """
      \(UInt128.max)
      """)
  }

  func testBigInt() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        print(BigInt.stdin)
        print(BigInt.stdin)
        print(BigInt.stdin)
      })
      .run(
        input:
          """
          \(Int128.max)
          \(Int128.min)
          \(UInt128.max)
          """),
      """
      \(Int128.max)
      \(Int128.min)
      \(UInt128.max)
      """)
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
#endif
