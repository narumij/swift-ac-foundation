import Algorithms
@preconcurrency import Foundation

/// 競技プログラミング用の solver を、指定した標準入力で実行するための補助型。
///
/// `run(input:)` は標準入力を差し替えて solver を実行し、標準出力に書き込まれた内容を文字列として返す。
/// テストコードから提出用の `solve()` 関数を検証するときに使う。
@available(macOS, introduced: 10.15)
public struct SolverRunner {

  /// 実行する solver を指定して runner を作成する。
  ///
  /// - Parameter solver: 標準入力を読み取り、標準出力へ結果を書き込む処理
  public init(solver: @escaping SolverRunner.Solver) {
    self.solver = solver
  }

  /// 標準入力を読み取り、標準出力へ結果を書き込む solver の型。
  public typealias Solver = () throws -> Void

  let solver: Solver

  /// 指定した文字列を標準入力として solver を実行し、標準出力の内容を返す。
  ///
  /// 入力末尾に改行がない場合は自動で追加する。返り値では末尾の改行を取り除く。
  ///
  /// - Parameter input: solver に渡す標準入力の内容
  /// - Returns: solver が標準出力へ書き込んだ内容
  /// - Throws: solver が投げたエラー
  public func run(input: String) throws -> String {
    try outputOnly {
      try inputOnly(input)
    }
  }

  /// 現在の標準入力のまま solver を実行し、標準出力の内容を返す。
  ///
  /// 返り値では末尾の改行を取り除く。
  ///
  /// - Returns: solver が標準出力へ書き込んだ内容
  /// - Throws: solver が投げたエラー
  public func outputOnly() throws -> String {
    try outputOnly {
      try solver()
    }
  }

  private func outputOnly(_ body: () throws -> Void) throws -> String {

    // パイプと標準出力のファイルディスクリプタを作成
    var pipefd = [Int32](repeating: 0, count: 2)
    pipe(&pipefd)
    var oldStdOut = dup(STDOUT_FILENO)

    func restoreStdout() {
      guard oldStdOut >= 0 else { return }
      fflush(stdout)
      dup2(oldStdOut, STDOUT_FILENO)
      close(oldStdOut)
      oldStdOut = -1
    }

    defer {
      restoreStdout()
      close(pipefd[0])
    }

    // 標準出力をパイプの書き込み端にリダイレクト
    dup2(pipefd[1], STDOUT_FILENO)
    close(pipefd[1])

    try body()
    restoreStdout()

    // パイプから読み取る
    var readBuffer = [UInt8](repeating: 0, count: 1024)
    var completeOutput = ""

    while true {
      let bytesRead = read(pipefd[0], &readBuffer, readBuffer.count)
      if bytesRead > 0 {
        // 読み取ったデータを文字列に変換して追加
        completeOutput += String(decoding: readBuffer.prefix(Int(bytesRead)), as: UTF8.self)
      } else {
        // もう読み取るデータがない場合
        break
      }
    }

    return String(completeOutput.trimmingSuffix { $0.isNewline })
  }

  /// 指定した文字列を標準入力として solver を実行する。
  ///
  /// 標準出力は差し替えないため、出力の検証が不要なテストや、入力処理だけを確認したい場合に使う。
  /// 入力末尾に改行がない場合は自動で追加する。
  ///
  /// - Parameter input: solver に渡す標準入力の内容
  /// - Throws: solver が投げたエラー
  public func inputOnly(_ input: String) throws {
    var input = input
    if input.last != "\n" {
      input.append("\n")
    }
    var inputBuffer: [Int8] = input.utf8CString.dropLast()
    let count = inputBuffer.count
    try inputBuffer.withUnsafeMutableBytes {
      let file = fmemopen($0.baseAddress, count, "r")
      assert(file != nil)
      let backup = stdin
      stdin = file!
      try solver()
      stdin = backup
    }
  }
}
