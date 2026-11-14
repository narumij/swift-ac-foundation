//
//  CharacterReadLineTests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2026/06/12.
//

import XCTest
import TestingUtil
import CharacterUtil

final class CharacterReadLineTests: XCTestCase {
  
  func test_readLine0() throws {
    XCTAssertEqual(
      try SolverRunner(solver: {
        let SS: [Character] = readLine()!
        print(String(SS))
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
        let SS: [Character] = readLine(strippingNewline: false)!
        print(String(SS))
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
