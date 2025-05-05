import Foundation

#if os(Linux)
  import Glibc  // dup, dup2, open, close
#else
  import Darwin
#endif

/// 与えられたファイルを標準入力として一時的にバインドし、
/// `body` が終わると必ず元に戻す。
///
/// - Parameters:
///   - url: 読み込み用ファイル URL（テスト用リソースなど）
///   - body: 差し替えた状態で実行したいクロージャ
/// - Throws: ファイルが開けない/dup に失敗した場合の POSIX エラー
@inline(__always)
func withStdinRedirected<T>(
  to url: URL,
  _ body: () throws -> T
) throws -> T {

  // ① テスト用ファイルを開く
  let fd = open(url.path, O_RDONLY)
  guard fd >= 0 else {
    throw NSError(
      domain: NSPOSIXErrorDomain,
      code: Int(errno))
  }

  // ② 元の stdin を退避
  let saved = dup(STDIN_FILENO)
  guard saved >= 0 else {
    close(fd)
    throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
  }

  // ③ dup2 で差し替え
  guard dup2(fd, STDIN_FILENO) >= 0 else {
    close(fd)
    close(saved)
    throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno))
  }
  close(fd)  // fd はもう不要（stdin と同じ FD に）

  // ④ defer で必ず復元
  defer {
    dup2(saved, STDIN_FILENO)
    close(saved)
    clearerr(stdin)
  }

  // ⑤ 本体を実行
  return try body()
}

private let fdLock = NSLock()

func withStdinRedirectedThreadSafe<T>(to url: URL, _ body: () throws -> T) throws -> T {
  fdLock.lock()
  defer { fdLock.unlock() }
  return try withStdinRedirected(to: url, body)
}
