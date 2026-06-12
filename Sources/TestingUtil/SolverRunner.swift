@preconcurrency import Foundation

@usableFromInline
let testingUtilFDLock = NSRecursiveLock()

@available(macOS, introduced: 10.15)
public struct SolverRunner {

  public init(solver: @escaping SolverRunner.Solver) {
    self.solver = solver
  }

  public typealias Solver = () throws -> Void

  let solver: Solver

  public func run(input: String) throws -> String {
    try outputOnly {
      try inputOnly(input)
    }
  }

  public func outputOnly() throws -> String {
    try outputOnly {
      try solver()
    }
  }

  private func outputOnly(_ body: () throws -> Void) throws -> String {
    testingUtilFDLock.lock()
    defer { testingUtilFDLock.unlock() }

    fflush(stdout)

    guard let outputFile = tmpfile() else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
    }
    defer { fclose(outputFile) }

    let outputFD = fileno(outputFile)
    var oldStdOut = dup(STDOUT_FILENO)
    guard oldStdOut >= 0 else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
    }

    func restoreStdout() {
      guard oldStdOut >= 0 else { return }
      fflush(stdout)
      dup2(oldStdOut, STDOUT_FILENO)
      close(oldStdOut)
      oldStdOut = -1
    }

    guard dup2(outputFD, STDOUT_FILENO) >= 0 else {
      let error = errno
      close(oldStdOut)
      oldStdOut = -1
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(error))
    }

    defer {
      restoreStdout()
    }

    try body()
    restoreStdout()

    guard fflush(outputFile) == 0 else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
    }
    guard fseek(outputFile, 0, SEEK_SET) == 0 else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
    }

    var readBuffer = [UInt8](repeating: 0, count: 1024)
    var completeOutput = ""

    while true {
      let bytesRead = fread(&readBuffer, 1, readBuffer.count, outputFile)
      if bytesRead > 0 {
        completeOutput += String(decoding: readBuffer.prefix(bytesRead), as: UTF8.self)
      } else if feof(outputFile) != 0 {
        break
      } else if ferror(outputFile) != 0 {
        throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
      }
    }

    return completeOutput.trimmingTrailingNewlines()
  }

  public func inputOnly(_ input: String) throws {
    testingUtilFDLock.lock()
    defer { testingUtilFDLock.unlock() }

    var input = input
    if input.last != "\n" {
      input.append("\n")
    }
    var inputBuffer: [Int8] = input.utf8CString.dropLast()
    let count = inputBuffer.count
    try inputBuffer.withUnsafeMutableBytes {
      let optionalFile = fmemopen($0.baseAddress, count, "r")
      guard optionalFile != nil else {
        throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
      }
      let file = optionalFile!
      let backup = stdin
      stdin = file
      clearerr(stdin)
      defer {
        stdin = backup
        fclose(file)
        clearerr(stdin)
      }
      try solver()
    }
  }
}

private extension String {
  func trimmingTrailingNewlines() -> String {
    var end = endIndex
    while end > startIndex {
      let previous = index(before: end)
      guard self[previous].isNewline else { break }
      end = previous
    }
    return String(self[..<end])
  }
}
