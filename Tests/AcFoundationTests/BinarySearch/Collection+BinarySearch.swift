import Foundation

// MARK: - Binary Search

extension Collection where Index == Int, Element: Comparable {

  @inlinable
  public func left(_ x: Element) -> Index {
    var (left, right) = (startIndex, endIndex)
    while left < right {
      let mid = (left + right) >> 1
      if self[mid] < x {
        left = mid + 1
      } else {
        right = mid
      }
    }
    return left
  }

  @inlinable
  public func right(_ x: Element) -> Index {
    var (left, right) = (startIndex, endIndex)
    while left < right {
      let mid = (left + right) >> 1
      if x < self[mid] {
        right = mid
      } else {
        left = mid + 1
      }
    }
    return left
  }
}
