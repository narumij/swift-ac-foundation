import XCTest
import TestingUtil
import UInt8Util

#if DEBUG
  @testable import IOReader
  import Pack
#else
  import IOReader
  import Pack
#endif

final class ReaderPerformanceTests: XCTestCase {
  #if DEBUG
    let stringFixtureA = ""
    let stringFixtureB = ""
  #else
    let stringFixtureA = String(
      (0..<5_000_000).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
    let stringFixtureB = String(
      (0..<5_000_000).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
  #endif

  func testPerformanceCChar1() throws {

    // This is an example of a performance test case.
    let a: [UInt8] = stringFixtureA.compactMap(\.asciiValue)
    let b: [UInt8] = stringFixtureB.compactMap(\.asciiValue)
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      for i in 0..<min(a.count, b.count) {
        c += a[i] == b[i] ? 1 : -1
      }
    }
  }

  func testPerformanceCharacter1() throws {

    // This is an example of a performance test case.
    let a = stringFixtureA.map { $0 }
    let b = stringFixtureB.map { $0 }
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      for i in 0..<min(a.count, b.count) {
        c += a[i] == b[i] ? 1 : -1
      }
    }
  }

  let stringFixtureAA = (0..<500).map { _ in
    String((0..<500).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
  }
  let stringFixtureBB = (0..<500).map { _ in
    String((0..<500).map { _ in Character(UnicodeScalar((UInt8(0x21)..<0x7e).randomElement()!)) })
  }

  func testPerformanceCChar2() throws {

    // This is an example of a performance test case.
    let a = stringFixtureAA.map { $0.compactMap(\.asciiValue) }
    let b = stringFixtureBB.map { $0.compactMap(\.asciiValue) }
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      let ii = (0..<500).shuffled()
      let jj = (0..<500).shuffled()
      for i in ii {
        for j in jj {
          c += a[i][j] == b[i][j] ? 1 : -1
        }
      }
    }
  }

  func testPerformanceCharacter2() throws {

    // This is an example of a performance test case.
    let a = stringFixtureAA.map { $0.map { $0 } }
    let b = stringFixtureBB.map { $0.map { $0 } }
    self.measure {
      // Put the code you want to measure the time of here.
      var c = 0
      let ii = (0..<500).shuffled()
      let jj = (0..<500).shuffled()
      for i in ii {
        for j in jj {
          c += a[i][j] == b[i][j] ? 1 : -1
        }
      }
    }
  }
}
