import Foundation

public struct Pack<each T> {
  
  public
    typealias Tuple = (repeat each T)

  public var tuple: Tuple
  
  @inlinable @inline(__always)
  public init(values: (repeat each T)) {
    self.tuple = (repeat each values)
  }
  
  @inlinable @inline(__always)
  public init(_ values: repeat each T) {
    self.tuple = (repeat each values)
  }
}

extension Pack: Equatable where repeat each T: Equatable {
  
  @inlinable @inline(__always)
  public static func == (lhs: Pack<repeat each T>, rhs: Pack<repeat each T>) -> Bool {
    for (l, r) in repeat (each lhs.tuple, each rhs.tuple) {
      if l != r {
        return false
      }
    }
    return true
  }
}

extension Pack: Comparable where repeat each T: Comparable {
  
  @inlinable @inline(__always)
  public static func < (lhs: Pack<repeat each T>, rhs: Pack<repeat each T>) -> Bool {
    for (l, r) in repeat (each lhs.tuple, each rhs.tuple) {
      if l != r {
        return l < r
      }
    }
    return false
  }
}

extension Pack: Hashable where repeat each T: Hashable {
  
  @inlinable @inline(__always)
  public func hash(into hasher: inout Hasher) {
    for l in repeat (each tuple) {
      hasher.combine(l)
    }
  }
}
