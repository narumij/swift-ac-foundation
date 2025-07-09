import Foundation

extension Array where Element: AdditiveArithmetic {
  @inlinable
  public mutating func resize(_ n: Int) {
    guard count != n else { return }
    if count > n {
      removeLast(count - n)
      return
    }
    reserveCapacity(Swift.max(count, n))
    append(contentsOf: repeatElement(.zero, count: n - count))
  }
}
