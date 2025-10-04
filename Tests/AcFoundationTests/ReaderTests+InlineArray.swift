//
//  ReadTests.swift
//
//
//  Created by narumij on 2023/12/18.
//

import Foundation
import XCTest

#if DEBUG
  @testable import IOReader
  import Pack
#else
  import IOReader
  import Pack
#endif

@available(macOS 26.0, *)
extension InlineArray where Element: SingleReadable {
  @inlinable @inline(__always)
  public static var stdin: Self { .init { _ in .stdin } }
}

@available(macOS 26.0, *)
extension InlineArray where Element: SingleReadable {
  func output() {
    for i in 0..<endIndex {
      if i != 0 {
        print(terminator: " ")
      }
      print(self[i], terminator: "")
    }
    print(terminator: "\n")
  }
}

@available(macOS 26.0, *)
final class InlineArrayReaderTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testRead1() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = [3 of Int].stdin
        A.output()
      })
      .run(
        input:
          """
          1 2 3
          """),

      """
      1 2 3
      """)
  }
}
