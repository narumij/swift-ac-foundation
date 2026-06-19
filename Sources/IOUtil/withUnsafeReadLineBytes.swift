import _FastIO

public
  enum IOUtilError: Swift.Error
{
  case unexpectedEmpty
}

/// 入力ライブラリを自作するときに、行単位の読み取りで詰まった場合の補助関数です。
/// `body` に渡されるバイト列は、この関数の呼び出し中だけ有効です。
@inlinable
@inline(__always)
public func withUnsafeReadLineBytes<T>(_ body: (UnsafeBufferPointer<UInt8>) throws -> T) throws -> T {
  var utf8Start: UnsafeMutablePointer<UInt8>?
  let utf8Count = _readLine_stdin(&utf8Start)
  defer {
    _free(utf8Start)
  }
  guard utf8Count > 0, let utf8Start else {
    throw IOUtilError.unexpectedEmpty
  }
  return try body(UnsafeBufferPointer(start: utf8Start, count: utf8Count))
}
