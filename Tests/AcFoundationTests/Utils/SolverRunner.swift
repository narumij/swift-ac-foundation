import Foundation
import Algorithms

@available(macOS, introduced: 10.15)
@globalActor
public struct STDIO {
    public static let shared: ActorType = ActorType()
    public actor ActorType { }
}

@available(macOS, introduced: 10.15)
@MainActor
public struct SolverRunner {
    
    public init(solver: @escaping SolverRunner.Solver) {
        self.solver = solver
    }
    
    public typealias Print = (String) -> Void
    
    public typealias Solver = () -> Void
    
    let solver: Solver
    
    public func run(input: String) -> String {
        
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
        
        var inputBuffer: [Int8] = input.utf8CString.dropLast() + [0x00,0x00]
        let count = inputBuffer.count
        inputBuffer.withUnsafeMutableBytes {
            let file = fmemopen($0.baseAddress, count, "r")
            assert(file != nil)
            let backup = stdin
            stdin = file!
            solver()
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
                completeOutput += String(cString: readBuffer + [0])
            } else {
                // もう読み取るデータがない場合
                break
            }
        }
        
        return String(completeOutput.trimmingSuffix { $0.isNewline })
    }
}
