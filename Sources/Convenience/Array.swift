import Foundation

extension Array where Element: AdditiveArithmetic {
  
  @inlinable
  public mutating func resize(_ n: Int) {
    resize(n, .zero)
  }

  @inlinable
  public func resized(_ n: Int) -> [Element] {
    var result = self
    result.resize(n)
    return result
  }
}

extension Array {
  
  @inlinable
  public mutating func resize(_ to: Int, _ element: Element) {
    guard count != to else { return }
    if count > to {
      removeLast(count - to)
      return
    }
    reserveCapacity(to)
    append(contentsOf: repeatElement(element, count: to - count))
  }

  @inlinable
  public mutating func resized(_ to: Int, _ element: Element) -> [Element] {
    var result = self
    result.resize(to, element)
    return result
  }
}
