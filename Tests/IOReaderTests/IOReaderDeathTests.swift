#if DEATH_TEST
  import Testing
  import TestingUtil

  import IOReader

  struct IOReaderDeathTests {

    @Test func numbersRows_traps_whenRowHasMoreValues() async throws {
      await #expect(processExitsWith: .failure) {
        try SolverRunner { _ = [Int].stdin(rows: 2) }.inputOnly("1 2")
      }
    }

    @Test func numbers2D_traps_whenRowHasMoreColumns() async throws {
      await #expect(processExitsWith: .failure) {
        try SolverRunner { _ = [[Int]].stdin(rows: 1, columns: 2) }.inputOnly("1 2 3")
      }
    }

    @Test func linesRowsColumns_traps_whenRowIsLonger() async throws {
      await #expect(processExitsWith: .failure) {
        try SolverRunner { _ = [String].stdin(rows: 1, columns: 2) }.inputOnly("###")
      }
    }

    @Test func words2D_traps_whenRowHasMoreColumns() async throws {
      await #expect(processExitsWith: .failure) {
        try SolverRunner { _ = [[String]].stdin(rows: 1, columns: 2) }.inputOnly("a b c")
      }
    }
  }
#endif
