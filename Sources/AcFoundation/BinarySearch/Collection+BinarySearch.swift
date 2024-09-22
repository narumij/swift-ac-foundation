import Foundation

// MARK: - Binary Search

extension Collection where Index == Int, Element: Comparable {

  @inlinable
  func left(_ x: Element, start left: Index, end right: Index) -> Index {
    var (left, right) = (left, right)
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
  func left(_ x: Element) -> Index {
    left(x, start: startIndex, end: endIndex)
  }

  @inlinable
  func right(_ x: Element, start left: Index, end right: Index) -> Index {
    var (left, right) = (left, right)
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

  @inlinable
  func right(_ x: Element) -> Index {
    right(x, start: startIndex, end: endIndex)
  }
}
