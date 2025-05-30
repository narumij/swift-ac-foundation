@preconcurrency import Foundation
import Algorithms

@available(macOS, introduced: 10.15)
public struct SolverRunner {
    
    public init(solver: @escaping SolverRunner.Solver) {
        self.solver = solver
    }
    
    public typealias Print = (String) -> Void
    
    public typealias Solver = () throws -> Void
    
    let solver: Solver
    
    public func run(input: String) throws -> String {
        
        var input = input
        if input.last != "\n" {
            input.append("\n")
        }
        
        // パイプと標準出力のファイルディスクリプタを作成
        var pipefd = [Int32](repeating: 0, count: 2)
        pipe(&pipefd)
        let oldStdOut = dup(STDOUT_FILENO)

        // 標準出力をパイプの書き込み端にリダイレクト
        dup2(pipefd[1], STDOUT_FILENO)
        close(pipefd[1])
        
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
        
        // 標準出力を元に戻す
        fflush(stdout)
        dup2(oldStdOut, STDOUT_FILENO)

        // パイプから読み取る
        var readBuffer = [CChar](repeating: 0, count: 1024)
        var completeOutput = ""

        while true {
            let bytesRead = read(pipefd[0], &readBuffer, 1024)
            if bytesRead > 0 {
                // 読み取ったデータを文字列に変換して追加
              completeOutput += String(utf8String: readBuffer) ?? ""
            } else {
                // もう読み取るデータがない場合
                break
            }
        }
        
        return String(completeOutput.trimmingSuffix { $0.isNewline })
    }
}
