import Foundation

public struct FileOutputStream: TextOutputStream {

  @usableFromInline let fileHandle: FileHandle

  @inlinable
  @inline(__always)
  public func write(_ s: String) {
    if let d = s.data(using: .utf8) {
      try? fileHandle.write(contentsOf: d)
    }
  }

  nonisolated(unsafe)
    public static var standardError: FileOutputStream = .init(
      fileHandle: FileHandle.standardError)

  nonisolated(unsafe)
    public static var standardOutput: FileOutputStream = .init(
      fileHandle: FileHandle.standardOutput)
}

public struct PutCharUnlockedStream: TextOutputStream {
  
  @inlinable
  @inline(__always)
  public func write(_ s: String) {
    if let d = s.data(using: .utf8) {
      d.withUnsafeBytes {
        for i in 0..<$0.count {
          putchar_unlocked(Int32($0[i]))
        }
      }
    }
  }

  nonisolated(unsafe)
    public static var standardOutput: PutCharUnlockedStream = .init()
}
