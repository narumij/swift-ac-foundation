@preconcurrency import Foundation

@available(macOS 10.15, *)
public struct StdoutSilencer {

  @inlinable
  public static func run(_ body: () throws -> Void) rethrows {
    let saved = dup(STDOUT_FILENO)
    let devNull = open("/dev/null", O_WRONLY)
    dup2(devNull, STDOUT_FILENO)
    close(devNull)

    defer {
      fflush(stdout)
      dup2(saved, STDOUT_FILENO)
      close(saved)
    }

    try body()
  }
}
