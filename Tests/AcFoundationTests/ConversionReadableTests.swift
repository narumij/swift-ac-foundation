import BigInt
import XCTest

#if DEBUG
  @testable import IOReader
#else
  import IOReader
#endif

//extension UInt: IOReadableInteger { }

extension UInt: IOStringConversionReadable {
  @inlinable @inline(__always)
  static public func convert(from: String) -> UInt { .init(from)! }
}

#if false
extension Int128: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}

extension UInt128: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}
#endif

extension BigInt: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(from)! }
}

//extension BigInt: IOIntegerConversionReadable {
//  @inlinable @inline(__always)
//  public static func convert(from: Int) -> Self { .init(from) }
//}

struct IntegerStub {
  var value: Int
}

extension IntegerStub: IOIntegerConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: Int) -> Self { .init(value: from) }
}

struct FloatingPointStub {
  var value: Double
}

extension FloatingPointStub: IOFloatingPointConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: Double) -> Self { .init(value: from) }
}

struct BytesStub {
  var value: [UInt8]
}

extension BytesStub: IOBytesConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: [UInt8]) -> Self { .init(value: from) }
}

struct StringStub {
  var value: String
}

extension StringStub: IOStringConversionReadable {
  @inlinable @inline(__always)
  public static func convert(from: String) -> Self { .init(value: from) }
}

final class ConversionReadableTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testIntegerStub() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(IntegerStub.stdin.value)
      })
      .run(
        input:
          """
          \(Int.max)
          """),
      """
      \(Int.max)
      """)
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        [IntegerStub].readLine()?.forEach { print($0.value) }
      })
      .run(
        input:
          """
          \(Int.max) \(Int.max)
          """),
      """
      \(Int.max)
      \(Int.max)
      """)
  }

  func testFloatingPointStub() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(FloatingPointStub.stdin.value)
      })
      .run(
        input:
          """
          \(Double.ulpOfOne)
          """),
      """
      \(Double.ulpOfOne)
      """)
  }

  func testStringStub() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(StringStub.stdin.value)
      })
      .run(
        input:
          """
          \(Int.max)
          """),
      """
      \(Int.max)
      """)
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        [StringStub].readLine()?.forEach { print($0.value) }
      })
      .run(
        input:
          """
          \(Int.max) \(Int.max)
          """),
      """
      \(Int.max)
      \(Int.max)
      """)
  }

  func testBytesStub() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        print(String(bytes: BytesStub.stdin.value, encoding: .ascii)!)
      })
      .run(
        input:
          """
          \(Int.max)
          """),
      """
      \(Int.max)
      """)
    
    XCTAssertEqual(
      try SolverRunner(solver: {
        [BytesStub].readLine()?.forEach { print(String(bytes: $0.value, encoding: .ascii)!) }
      })
      .run(
        input:
          """
          \(Int.max) \(Int.max)
          """),
      """
      \(Int.max)
      \(Int.max)
      """)
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

#if false
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
#endif

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
