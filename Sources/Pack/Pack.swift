import Foundation

public struct Pack<each T> {
  
  public typealias RawValue = (repeat each T)

  public var rawValue: RawValue
  
  @inlinable
  @inline(__always)
  public init(rawValue: (repeat each T)) {
    self.rawValue = (repeat each rawValue)
  }
  
  @inlinable
  @inline(__always)
  public init(_ values: repeat each T) {
    self.rawValue = (repeat each values)
  }
}

extension Pack: Equatable where repeat each T: Equatable {
  
  @inlinable
  @inline(__always)
  public static func == (lhs: Pack<repeat each T>, rhs: Pack<repeat each T>) -> Bool {
    for (l, r) in repeat (each lhs.rawValue, each rhs.rawValue) {
      if l != r {
        return false
      }
    }
    return true
  }
}

extension Pack: Comparable where repeat each T: Comparable {
  
  @inlinable
  @inline(__always)
  public static func < (lhs: Pack<repeat each T>, rhs: Pack<repeat each T>) -> Bool {
    for (l, r) in repeat (each lhs.rawValue, each rhs.rawValue) {
      if l != r {
        return l < r
      }
    }
    return false
  }
}

extension Pack: Hashable where repeat each T: Hashable {
  
  @inlinable
  @inline(__always)
  public func hash(into hasher: inout Hasher) {
    for l in repeat (each rawValue) {
      hasher.combine(l)
    }
  }
}
