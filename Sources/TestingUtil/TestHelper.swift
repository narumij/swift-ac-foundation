@preconcurrency import Foundation

#if os(Linux)
  @preconcurrency import Glibc
#else
  @preconcurrency import Darwin
#endif

/// 与えられたファイルを標準入力として一時的にバインドし、
/// `body` が終わると必ず元に戻す。
///
/// - Parameters:
///   - url: 読み込み用ファイル URL（テスト用リソースなど）
///   - body: 差し替えた状態で実行したいクロージャ
/// - Throws: ファイルが開けない/dup に失敗した場合の POSIX エラー
@inline(__always)
public func withStdinRedirected<T>(
  to url: URL,
  _ body: () throws -> T
) throws -> T {
  testingUtilFDLock.lock()
  defer { testingUtilFDLock.unlock() }

  let fd = open(url.path, O_RDONLY)
  guard fd >= 0 else {
    throw NSError(
      domain: NSPOSIXErrorDomain,
      code: Int(errno))
  }

  let saved = dup(STDIN_FILENO)
  guard saved >= 0 else {
    close(fd)
    throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
  }

  guard dup2(fd, STDIN_FILENO) >= 0 else {
    close(fd)
    close(saved)
    throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
  }
  close(fd)

  defer {
    dup2(saved, STDIN_FILENO)
    close(saved)
    clearerr(stdin)
  }

  return try body()
}

public func withStdinRedirectedThreadSafe<T>(to url: URL, _ body: () throws -> T) throws -> T {
  try withStdinRedirected(to: url, body)
}
