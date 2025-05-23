@preconcurrency import Foundation

#if os(macOS) || os(iOS)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif os(Windows)
import ucrt
#else
#error("Unknown platform")
#endif

// MARK: - STDERR

extension UnsafeMutablePointer: @retroactive TextOutputStream where Pointee == FILE {
  /// FILEを指すポインタにTextOutputStreamプロトコルを適用しています
  ///
  /// これにより、stderrやstdoutを以下のように利用することができます。
  /// ```
  /// print("Hello, world!", to: &stderr)
  /// ```
  @inlinable
  public mutating func write(_ string: String) {
    guard let data = string.data(using: .utf8) else { return }
    _ = data.withUnsafeBytes { bytes in
#if os(macOS) || os(iOS)
      Darwin.write(fileno(self), bytes.baseAddress!, data.count)
#elseif canImport(Glibc)
      Glibc.write(fileno(self), bytes.baseAddress!, data.count)
#else
#error("Not implemented yet")
#endif
    }
  }
}

#if swift(>=5.5)
extension UnsafeMutablePointer: @unchecked @retroactive Sendable {}
#endif
