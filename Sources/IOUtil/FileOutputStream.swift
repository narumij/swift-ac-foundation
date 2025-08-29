import Foundation

public struct FileOutputStream: TextOutputStream {
  @usableFromInline
  let handle: FileHandle
  @inlinable
  public func write(_ s: String) {
    if let d = s.data(using: .utf8) { try? handle.write(contentsOf: d) }
  }
  nonisolated(unsafe) public static var standardError: FileOutputStream = .init(handle: FileHandle.standardError)
  nonisolated(unsafe) public static var standardOutput: FileOutputStream = .init(handle: FileHandle.standardOutput)
}
