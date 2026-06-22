import Foundation

/// 標準入力からトークン単位で値を得る
///
/// 使用例
/// ```swift
/// let N = simple_readint()
/// let A = (0..<N).map { _ in simple_readInt() }
/// ```
@inlinable
@inline(__always)
func simple_readInt() -> Int {
  var c = getchar_unlocked()

  while c == 9 || c == 10 || c == 13 || c == 32 {
    c = getchar_unlocked()
  }

  let isNegative = c == 45
  if isNegative {
    c = getchar_unlocked()
  }

  var value = 0

  while 48...57 ~= c {
    value = value &* 10 &+ Int(c &- 48)
    c = getchar_unlocked()
  }

  if isNegative {
    return value == Int.min ? value : -value
  }

  return value
}
