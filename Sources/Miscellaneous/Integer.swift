/// 床関数
///
/// evimaさんの解説を参考にした記憶です
@inlinable
@inline(__always)
public func floor(_ n: Int, _ d: Int) -> Int {
  (n - (n % d + d) % d) / d
}

/// 天井関数
///
/// evimaさんの解説を参考にした記憶です
@inlinable
@inline(__always)
public func ceil(_ n: Int, _ d: Int) -> Int {
  (n + (d - n % d) % d) / d
}

/// ユークリッド剰余関数
///
/// evimaさんの解説を参考にした記憶です
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

/// 拡張ユークリッドの互除法の実装例
///
/// ax+by=±gcd(a,b) となる整数の組 (x,y) を O(logmin(∣a∣,∣b∣)) で計算するアルゴリズム
///
/// ここで整数の組 x,y は max(∣x∣,∣y∣)≤max(∣a∣,∣b∣) を満たす整数であることが保証されています。
///
/// I - S = 1 解説を参考にしました。
func extgcd(_ a: Int,_ b: Int) -> (Int,Int) {
  if (b == 0) { return (1, 0) }
  var x, y: Int
  (y, x) = extgcd(b, a % b)
  y -= a / b * x;
  return (x, y)
}
