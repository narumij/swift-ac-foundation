#if DEATH_TEST
  import IOReader
  import TestingUtil
  import Testing

  // ReaderUnexpectedEOFTests.swift の EOF・区切りエラーのケースを、V2 の try! による停止を確かめる exit test にしたもの。
  struct ReaderUnexpectedEOFTests {

    @Test func testUnexpectedEOF1_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [Int].stdin(rows: 3) }.run(input: "1\n2")
      }
    }

    @Test func testUnexpectedEOF2_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [Double].stdin(rows: 3) }.run(input: "1\n2")
      }
    }

    @Test func testUnexpectedEOF3_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = String.stdin }.run(input: "")
      }
    }

    @Test func testUnexpectedEOF4_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [UInt8].stdin }.run(input: "")
      }
    }

    @Test func testUnexpectedEOF5_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String.stdin(columns: 4)] }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF5_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String].stdin(rows: 4) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF5_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String].stdin(rows: 3, columns: 4) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF5_4() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String].stdin(rows: 4, columns: 3) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF6_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[Character].stdin(columns: 4)] }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF6_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[Character]].stdin(rows: 3, columns: 4) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF6_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[Character]].stdin(rows: 4, columns: 3) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF7_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8].stdin(columns: 4)] }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF7_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8]].stdin(rows: 3, columns: 4) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF7_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8]].stdin(rows: 4, columns: 3) }.run(input: "aaa\nbbb\nccc")
      }
    }

    @Test func testUnexpectedEOF8_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [ [Int.stdin, Int.stdin, Int.stdin, Int.stdin], [Int.stdin, Int.stdin, Int.stdin], ] }.run(input: "1 2 3\n4 5 6")
      }
    }

    @Test func testUnexpectedEOF8_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [ [Int].stdin(columns: 4), [Int].stdin(columns: 3), ] }.run(input: "1 2 3\n4 5 6")
      }
    }

    @Test func testUnexpectedEOF8_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[Int]].stdin(rows: 2, columns: 4) }.run(input: "1 2 3\n4 5 6")
      }
    }

    @Test func testUnexpectedEOF9_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [ [Double.stdin, Double.stdin, Double.stdin, Double.stdin], [Double.stdin, Double.stdin, Double.stdin], ] }.run(input: "1 2 3\n4 5 6")
      }
    }

    @Test func testUnexpectedEOF9_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [ [Double].stdin(columns: 4), [Double].stdin(columns: 3), ] }.run(input: "1 2 3\n4 5 6")
      }
    }

    @Test func testUnexpectedEOF9_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[Double]].stdin(rows: 2, columns: 4) }.run(input: "1 2 3\n4 5 6")
      }
    }

    @Test func testUnexpectedEOF10_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String.stdin(columns: 3), String.stdin(columns: 3)] }.run(input: "aaa\nc c")
      }
    }

    @Test func testUnexpectedEOF10_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String.stdin(columns: 3), String.stdin(columns: 3)] }.run(input: "a\ta\nccc")
      }
    }

    @Test func testUnexpectedEOF10_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String].stdin(rows: 2, columns: 3) }.run(input: "a a\nbbb")
      }
    }

    @Test func testUnexpectedEOF10_4() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String].stdin(rows: 2, columns: 3) }.run(input: "aaa\nb\tb")
      }
    }

    @Test func testUnexpectedEOF11_1() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8].stdin(columns: 3), [UInt8].stdin(columns: 3)] }.run(input: "aaa\nc c")
      }
    }

    @Test func testUnexpectedEOF11_2() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8].stdin(columns: 3), [UInt8].stdin(columns: 3)] }.run(input: "a\ta\nccc")
      }
    }

    @Test func testUnexpectedEOF11_3() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8]].stdin(rows: 2, columns: 3) }.run(input: "a a\nbbb")
      }
    }

    @Test func testUnexpectedEOF11_4() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[UInt8]].stdin(rows: 2, columns: 3) }.run(input: "aaa\nb\tb")
      }
    }
  }
#endif
