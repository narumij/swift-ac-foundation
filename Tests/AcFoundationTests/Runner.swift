import Foundation

@available(macOS, introduced: 10.15)
@globalActor
public struct STDIN {
    public static let shared: ActorType = ActorType()
    public actor ActorType { }
}

@available(macOS, introduced: 10.15)
@STDIN
public struct SolverRunner {
    
    public init(solver: @escaping SolverRunner.Solver) {
        self.solver = solver
    }
    
    public typealias Print = (String) -> Void
    
    public typealias Solver = (Print) -> Void
    
    let solver: Solver
    
    public func run(input: String) -> String {
        var input = input
        if input.last != "\n" {
            input.append("\n")
        }
        var output: [String] = []
        var buffer: [Int8] = input.utf8CString.dropLast() + [0x00,0x00]
        let count = buffer.count
        buffer.withUnsafeMutableBytes {
            let file = fmemopen($0.baseAddress, count, "r")
            assert(file != nil)
            let backup = stdin
            stdin = file!
            solver() {
                output.append($0)
            }
            stdin = backup
        }
        return output.joined(separator: "\n")
    }
}
