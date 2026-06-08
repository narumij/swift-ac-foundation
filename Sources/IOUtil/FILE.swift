#if canImport(Glibc)
  @preconcurrency import Glibc
#else
  @preconcurrency import Darwin
#endif

extension UnsafeMutablePointer: @retroactive TextOutputStream where Pointee == FILE {
  
  public mutating func write(_ string: String) {
    guard let data = string.data(using: .utf8) else { return }
    _ = data.withUnsafeBytes { bytes in
      #if canImport(Glibc)
        Glibc.write(fileno(self), bytes.baseAddress!, data.count)
      #else
        Darwin.write(fileno(self), bytes.baseAddress!, data.count)
      #endif
    }
  }
}
