//
//  CxxMT19937Tests.swift
//  swift-ac-foundation
//
//  Created by narumij on 2025/08/09.
//

import CxxMT19937
import XCTest

final class CxxMT19937Tests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }

  func testCopiesAdvanceIndependently() {
    var original = mt19937_64(seed: 123)
    // Copy partway through the state, then cross several state refreshes.
    original.discard(400)
    var copy = original
    var reference = mt19937_64(seed: 123)
    reference.discard(400)
    for _ in 0..<1_000 {
      let expected = reference.next()
      XCTAssertEqual(original.next(), expected)
      XCTAssertEqual(copy.next(), expected)
    }
  }

  func testDiscardOnCopyDoesNotAdvanceOriginal() {
    var original = mt19937_64(seed: 456)
    original.discard(400)
    var copy = original
    copy.discard(700)
    var reference = mt19937_64(seed: 456)
    reference.discard(400)
    XCTAssertEqual(original.next(), reference.next())
    var advancedReference = mt19937_64(seed: 456)
    advancedReference.discard(1_100)
    XCTAssertEqual(copy.next(), advancedReference.next())
  }

  func testDiscardOnOriginalDoesNotAdvanceCopy() {
    var original = mt19937_64(seed: 789)
    original.discard(400)
    var copy = original
    original.discard(700)
    var reference = mt19937_64(seed: 789)
    reference.discard(400)
    XCTAssertEqual(copy.next(), reference.next())
    var advancedReference = mt19937_64(seed: 789)
    advancedReference.discard(1_100)
    XCTAssertEqual(original.next(), advancedReference.next())
  }

  func testCopiesUsedByConcurrentTasksAreIndependent() async {
    var original = mt19937_64(seed: 123)
    original.discard(400)
    let snapshot = original
    var reference = mt19937_64(seed: 123)
    reference.discard(400)
    let expected = (0..<1_000).map { _ in reference.next() }
    await withTaskGroup(of: [UInt64].self) { group in
      for _ in 0..<8 {
        group.addTask {
          var local = snapshot
          return (0..<1_000).map { _ in local.next() }
        }
      }
      for await values in group {
        XCTAssertEqual(values, expected)
      }
    }
    XCTAssertEqual(original.next(), expected[0])
  }

  func testRandom() throws {
    var mt = mt19937_64(seed: 0)
    let randomNumber = Int.random(in: Int.min...Int.max, using: &mt)
    let randomDouble = Double.random(in: 0...1, using: &mt)
    XCTAssertTrue((Int.min...Int.max).contains(randomNumber))
  }
  
  func testRandom2() throws {
    var mt = mt19937_64(seed: 0)
    XCTAssertNotEqual([mt.next(), mt.next(), mt.next(), mt.next()], [])
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
