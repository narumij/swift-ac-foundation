import Foundation

/// 累積和1D
@inlinable
public func prefixSum<T>(N: Int, _ A: [T]) -> [T] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
  var s: [T] = [0] * (N + 1)
  for i in 0..<N {
    s[i + 1] =
      s[i]
      + A[i]
  }
  return s
}

/// 累積和1D
@inlinable
public func prefixSum<T>(_ A: [T]) -> [T] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
  prefixSum(N: A.count, A)
}

/// 累積和2D
@inlinable
public func prefixSum<T>(N: Int, M: Int, _ A: [[T]]) -> [[T]] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
  var s: [[T]] = [0] * (N + 1, M + 1)
  for i in 0..<N {
    for j in 0..<M {
      s[i + 1][j + 1] =
        s[i + 1][j]
        + s[i][j + 1]
        - s[i][j]
        + A[i][j]
    }
  }
  return s
}

/// 累積和2D
@inlinable
public func prefixSum<T>(_ A: [[T]]) -> [[T]] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
  let N = A.count
  let M = A[0].count
  assert(A.allSatisfy { $0.count == M })
  return prefixSum(N: N, M: M, A)
}

/// 累積和3D
@inlinable
public func prefixSum<T>(N: Int, M: Int, L: Int, _ A: [[[T]]]) -> [[[T]]] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
  var s: [[[T]]] = [0] * (N + 1, M + 1, L + 1)
  for i in 0..<N {
    for j in 0..<M {
      for k in 0..<L {
        s[i + 1][j + 1][k + 1] =
          s[i + 1][j + 1][k]
          + s[i + 1][j][k + 1]
          + s[i][j + 1][k + 1]
          - s[i + 1][j][k]
          - s[i][j + 1][k]
          - s[i][j][k + 1]
          + s[i][j][k]
          + A[i][j][k]
      }
    }
  }
  return s
}

/// 累積和3D
@inlinable
public func prefixSum<T>(_ A: [[[T]]]) -> [[[T]]] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
  let N = A.count
  let M = A[0].count
  let L = A[0][0].count
  assert(A.allSatisfy { $0.count == M })
  assert(A.allSatisfy { $0.allSatisfy { $0.count == L } })
  return prefixSum(N: N, M: M, L: L, A)
}
