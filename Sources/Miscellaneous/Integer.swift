/// 床関数
@inlinable
func floor(_ n: Int, _ d: Int) -> Int {
  (n - (n % d + d) % d) / d
}

/// 天井関数
@inlinable
func ceil(_ n: Int, _ d: Int) -> Int {
  (n + (d - n % d) % d) / d
}

/// ユークリッド剰余関数
@inlinable
func mod(_ n: Int, _ d: Int) -> Int {
  let a = n % d
  return a < 0 ? a + d : a
}

/// 割った余りを計算する時のやつパート1
@usableFromInline let MOD_998_244_353 = 998_244_353

/// 割った余りを計算する時のやつパート2
@usableFromInline let MOD_1_000_000_007 = 1_000_000_007
