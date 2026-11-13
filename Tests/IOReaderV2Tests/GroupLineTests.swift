import IOReaderV2
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
