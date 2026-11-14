#if DEATH_TEST
  import IOReader
  import Pack
  import TestingUtil
  import Testing

  // 1つのグループは1行に収まり、rows では1行に1グループずつ並ぶことを確かめる
  struct GroupLineTests {

    @Test func simdRowsSucceed() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner { _ = [SIMD2<Int>].stdin(rows: 2) }.run(input: "1 2\n3 4\n")
      }
    }

    @Test func simdRowWithExtraValueStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [SIMD2<Int>].stdin(rows: 2) }.run(input: "1 2 3\n4 5\n")
      }
    }

    @Test func simdAcrossLinesStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = SIMD2<Int>.stdin }.run(input: "1\n2\n")
      }
    }

    @Test func tupleOnOneLineSucceeds() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner { let _: (Int, Character) = stdin() }.run(input: "1 a\n")
      }
    }

    @Test func tupleAcrossLinesStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { let _: (Int, Character) = stdin() }.run(input: "1\na\n")
      }
    }

    @Test func packRowsSucceed() async {
      if #available(macOS 14.0, *) {
        await #expect(processExitsWith: .success) {
          _ = try SolverRunner { _ = [Pack<Int, Character>].stdin(rows: 2) }.run(input: "1 a\n2 b\n")
        }
      }
    }

    @Test func packAcrossLinesStops() async {
      if #available(macOS 14.0, *) {
        await #expect(processExitsWith: .failure) {
          _ = try SolverRunner { _ = Pack<Int, Character>.stdin }.run(input: "1\na\n")
        }
      }
    }
  }

  // columns 個は1行に収まり、行末の空白は行の終わりとして受け入れる
  struct ColumnsLineTests {

    @Test func columnsAcrossLinesStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [Int32].stdin(columns: 3) }.run(input: "1 2\n3\n")
      }
    }

    @Test func columnsWithTrailingSpaceSucceed() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner {
          precondition([Int32].stdin(columns: 2) == [1, 2])
          precondition(Int32.stdin == 3)
        }.run(input: "1 2 \n3\n")
      }
    }
  }

  // rows は1行に1つずつ並ぶ
  struct NumericRowsLineTests {

    @Test func rowsSucceed() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner {
          precondition([Int32].stdin(rows: 2) == [1, 2])
          precondition(Int32.stdin == 3)
        }.run(input: "1\n2\n3\n")
      }
    }

    @Test func rowsWithTwoValuesOnALineStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [Int32].stdin(rows: 2) }.run(input: "1 2\n3\n")
      }
    }

    // 具象の [Int].stdin(rows:) も同じく1行に1つずつ
    @Test func concreteIntRowsSucceed() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner {
          precondition([Int].stdin(rows: 2) == [1, 2])
          precondition(Int.stdin == 3)
        }.run(input: "1\n2\n3\n")
      }
    }

    @Test func concreteIntRowsWithTwoValuesOnALineStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [Int].stdin(rows: 2) }.run(input: "1 2\n3\n")
      }
    }
  }

  // 具象の [Int] / [String] の columns も1行に収まる
  struct ConcreteColumnsLineTests {

    @Test func concreteIntColumnsAcrossLinesStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [Int].stdin(columns: 3) }.run(input: "1 2\n3\n")
      }
    }

    @Test func concreteStringColumnsAcrossLinesStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [String].stdin(columns: 3) }.run(input: "a b\nc\n")
      }
    }

    @Test func concreteColumnsSucceed() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner {
          precondition([Int].stdin(columns: 2) == [1, 2])
          precondition([String].stdin(columns: 2) == ["a", "b"])
        }.run(input: "1 2\na b\n")
      }
    }

    @Test func concreteRowsColumnsAcrossLinesStops() async {
      await #expect(processExitsWith: .failure) {
        _ = try SolverRunner { _ = [[Int]].stdin(rows: 1, columns: 2) }.run(input: "1\n2\n")
      }
    }

    @Test func concreteRowsColumnsWithTrailingSpaceSucceed() async {
      await #expect(processExitsWith: .success) {
        _ = try SolverRunner {
          precondition([[Int]].stdin(rows: 2, columns: 2) == [[1, 2], [3, 4]])
          precondition([[String]].stdin(rows: 1, columns: 2) == [["a", "b"]])
        }.run(input: "1 2 \n3 4\na b \n")
      }
    }
  }
#endif
