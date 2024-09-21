import Foundation

// MARK: - STDERR

extension UnsafeMutablePointer: TextOutputStream where Pointee == FILE {
  @inlinable
  public mutating func write(_ string: String) {
    guard let data = string.data(using: .utf8) else { return }
    _ = data.withUnsafeBytes { bytes in
      #if os(Linux)
        Glibc.write(fileno(self), bytes.baseAddress!, data.count)
      #else
        Darwin.write(fileno(self), bytes.baseAddress!, data.count)
      #endif
    }
  }
}
