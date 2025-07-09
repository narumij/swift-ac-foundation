/// 床関数
///
/// evimaさんを参考にした記憶です
@inlinable
@inline(__always)
public func floor(_ n: Int, _ d: Int) -> Int {
  (n - (n % d + d) % d) / d
}

/// 天井関数
///
/// evimaさんを参考にした記憶です
@inlinable
@inline(__always)
public func ceil(_ n: Int, _ d: Int) -> Int {
  (n + (d - n % d) % d) / d
}

/// ユークリッド剰余関数
///
/// evimaさんを参考にした記憶です
@inlinable
@inline(__always)
public func mod(_ n: Int, _ d: Int) -> Int {
  let a = n % d
  return a < 0 ? a + d : a
}

/// 割った余りを計算する時のやつパート1
public let MOD_998_244_353 = 998_244_353

/// 割った余りを計算する時のやつパート2
public let MOD_1_000_000_007 = 1_000_000_007
