import IOReader
import Pack
import TestingUtil
import UInt8Util
import XCTest

final class ReaderLineTests: XCTestCase {
  func testReadLine() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Int] = try .readLine()
        print(A)
        let B: [Int] = (0..<5).map { _ in .stdin }
        XCTAssertEqual(B, [6, 7, 8, 9, 10])
        let C: [Int] = try .readLine()
        XCTAssertEqual(C, [11, 12])
        XCTAssertNil(try? [Int].readLine())
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10 11 12
          """),

      """
      [1, 2, 3, 4, 5]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Double] = try .readLine()
        print(A)
        let B: [Int] = (0..<5).map { _ in .stdin }
        XCTAssertEqual(B, [6, 7, 8, 9, 10])
        let C: [Double] = try .readLine()
        XCTAssertEqual(C, [11, 12])
        XCTAssertNil(try? [Int].readLine())
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10 11 12
          """),

      """
      [1.0, 2.0, 3.0, 4.0, 5.0]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [String] = try .readLine()
        print(A)
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = try .readLine()
        XCTAssertEqual(C, ["Foo", "Bar"])
        XCTAssertNil(try? [String].readLine())
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[Character]] = try .readLine()
        print(A.map { String($0) })
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = try .readLine()
        XCTAssertEqual(C, ["Foo", "Bar"])
        XCTAssertNil(try? [[UInt8]].readLine())
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[UInt8]] = try .readLine()
        print(A.map { String(bytes: $0, encoding: .ascii)! })
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = try .readLine()
        XCTAssertEqual(C, ["Foo", "Bar"])
        XCTAssertNil(try? [[UInt8]].readLine())
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = String(bytes: [UInt8].readLine()!, encoding: .ascii)!
        let B = String([Character].readLine()!)
        print(A)
        print(B)
        XCTAssertEqual(A, "Takahashi Aoki")
        XCTAssertEqual(B, "Tanaka Aoi Foo Bar")
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      Takahashi Aoki
      Tanaka Aoi Foo Bar
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A = String([Character].readLine()!)
        let B = String(bytes: [UInt8].readLine()!, encoding: .ascii)!
        print(A)
        print(B)
        XCTAssertEqual(A, "Takahashi Aoki")
        XCTAssertEqual(B, "Tanaka Aoi Foo Bar")
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      Takahashi Aoki
      Tanaka Aoi Foo Bar
      """)

    _ = try SolverRunner(solver: {
      let A = Swift.readLine()
      XCTAssertEqual(A, "Takahashi Aoki")
    })
    .run(input: "Takahashi Aoki")

    _ = try SolverRunner(solver: {
      let A = [Character].readLine()!
      XCTAssertEqual(A, "Takahashi Aoki".map { $0 })
    })
    .run(input: "Takahashi Aoki")

    _ = try SolverRunner(solver: {
      let A = [UInt8].readLine()!
      XCTAssertEqual(A, "Takahashi Aoki".asciiValues)
    })
    .run(input: "Takahashi Aoki")
  }

  func testReadLine2() throws {

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Int] = .stdin()
        print(A)
        let B: [Int] = (0..<5).map { _ in .stdin }
        XCTAssertEqual(B, [6, 7, 8, 9, 10])
        let C: [Int] = .stdin()
        XCTAssertEqual(C, [11, 12])
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10 11 12
          """),

      """
      [1, 2, 3, 4, 5]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [Double] = .stdin()
        print(A)
        let B: [Int] = (0..<5).map { _ in .stdin }
        XCTAssertEqual(B, [6, 7, 8, 9, 10])
        let C: [Double] = .stdin()
        XCTAssertEqual(C, [11, 12])
      })
      .run(
        input:
          """
          1 2 3 4 5
          6 7 8 9 10 11 12
          """),

      """
      [1.0, 2.0, 3.0, 4.0, 5.0]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [String] = .stdin()
        print(A)
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = .stdin()  // 部分を読んでも後続が行末まで読めること
        XCTAssertEqual(C, ["Foo", "Bar"])
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[Character]] = .stdin()
        print(A.map { String($0) })
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = .stdin()
        XCTAssertEqual(C, ["Foo", "Bar"])
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    XCTAssertEqual(
      try SolverRunner(solver: {
        let A: [[UInt8]] = .stdin()
        print(A.map { String(bytes: $0, encoding: .ascii)! })
        let B: [String] = (0..<2).map { _ in .stdin }
        XCTAssertEqual(B, ["Tanaka", "Aoi"])
        let C: [String] = .stdin()
        XCTAssertEqual(C, ["Foo", "Bar"])
      })
      .run(
        input:
          """
          Takahashi Aoki
          Tanaka Aoi Foo Bar
          """),

      """
      ["Takahashi", "Aoki"]
      """)

    #if false
      XCTAssertEqual(
        try SolverRunner(solver: {
          let A = String(bytes: [UInt8].stdin(), encoding: .ascii)!
          let B = String([Character].stdin())
          print(A)
          print(B)
          XCTAssertEqual(A, "Takahashi Aoki")
          XCTAssertEqual(B, "Tanaka Aoi Foo Bar")
        })
        .run(
          input:
            """
            Takahashi Aoki
            Tanaka Aoi Foo Bar
            """),

        """
        Takahashi Aoki
        Tanaka Aoi Foo Bar
        """)

      XCTAssertEqual(
        try SolverRunner(solver: {
          let A = String([Character].stdin())
          let B = String(bytes: [UInt8].stdin(), encoding: .ascii)!
          print(A)
          print(B)
          XCTAssertEqual(A, "Takahashi Aoki")
          XCTAssertEqual(B, "Tanaka Aoi Foo Bar")
        })
        .run(
          input:
            """
            Takahashi Aoki
            Tanaka Aoi Foo Bar
            """),

        """
        Takahashi Aoki
        Tanaka Aoi Foo Bar
        """)
    #endif
  }
}
