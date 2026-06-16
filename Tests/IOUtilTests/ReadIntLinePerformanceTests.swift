import XCTest
import TestingUtil
import IOReader
import IOUtil

final class ReadIntLinePerformanceTests: XCTestCase {

  private func makeIntLineInput(
    count: Int,
    modulo: Int = 1_000_000_007,
    signed: Bool = false
  ) -> String {
    var input = ""
    input.reserveCapacity(count * 12)

    for i in 0..<count {
      if i > 0 {
        input.append(" ")
      }

      let value = i % modulo

      if signed && (i & 1 == 1) {
        input.append("-")
      }

      input.append(String(value))
    }

    input.append("\n")
    return input
  }

  // MARK: - Small Ints

  func testReadIntLineOldPerformanceManySmallInts() throws {
    let input = makeIntLineInput(count: 100_000, modulo: 10_000)

    let runner = SolverRunner {
      let values = readIntLine() as [Int]
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  func testReadIntLineNewPerformanceManySmallInts() throws {
    let input = makeIntLineInput(count: 100_000, modulo: 10_000)

    let runner = SolverRunner {
      let values = readIntLine_new() as [Int]
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  func testArrayStdinPerformanceManySmallInts() throws {
    let input = makeIntLineInput(count: 100_000, modulo: 10_000)

    let runner = SolverRunner {
      let values = [Int].stdin()
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  // MARK: - Large Ints

  func testReadIntLineOldPerformanceManyLargeInts() throws {
    let input = makeIntLineInput(count: 100_000, modulo: 1_000_000_007)

    let runner = SolverRunner {
      let values = readIntLine() as [Int]
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  func testReadIntLineNewPerformanceManyLargeInts() throws {
    let input = makeIntLineInput(count: 100_000, modulo: 1_000_000_007)

    let runner = SolverRunner {
      let values = readIntLine_new() as [Int]
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  func testArrayStdinPerformanceManyLargeInts() throws {
    let input = makeIntLineInput(count: 100_000, modulo: 1_000_000_007)

    let runner = SolverRunner {
      let values = [Int].stdin()
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  // MARK: - Signed Ints

  func testReadIntLineOldPerformanceSignedInts() throws {
    let input = makeIntLineInput(
      count: 100_000,
      modulo: 1_000_000,
      signed: true
    )

    let runner = SolverRunner {
      let values = readIntLine() as [Int]
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  func testReadIntLineNewPerformanceSignedInts() throws {
    let input = makeIntLineInput(
      count: 100_000,
      modulo: 1_000_000,
      signed: true
    )

    let runner = SolverRunner {
      let values = readIntLine_new() as [Int]
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }

  func testArrayStdinPerformanceSignedInts() throws {
    let input = makeIntLineInput(
      count: 100_000,
      modulo: 1_000_000,
      signed: true
    )

    let runner = SolverRunner {
      let values = [Int].stdin()
      XCTAssertEqual(values.count, 100_000)
    }

    measure {
      try! runner.inputOnly(input)
    }
  }
}
