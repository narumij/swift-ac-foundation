import Foundation
import IOReader

// どうぞご自由にお使いください。

@frozen
public struct Pack2<T,U> {
  
  public typealias RawValue = (T,U)

  public var rawValue: RawValue
  
  @inlinable
  @inline(__always)
  public init(_ t: T,_ u: U) {
    self.rawValue = (t,u)
  }
  
  @inlinable
  @inline(__always)
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Pack2: Equatable where T: Equatable, U: Equatable {
  
  @inlinable
  @inline(__always)
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension Pack2: Comparable where T: Comparable, U: Comparable {
  
  @inlinable
  @inline(__always)
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Pack2: Hashable where repeat T: Hashable, U: Hashable {
  
  @inlinable
  @inline(__always)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue.0)
    hasher.combine(rawValue.1)
  }
}

extension Pack2: SingleReadable where T: SingleReadable, U: SingleReadable {
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try .read(), try .read())
  }
}

extension Pack2: Sendable where T: Sendable, U: Sendable { }

extension Pack2 {
  
  var first: T {
    get { rawValue.0 }
    set { rawValue.0 = newValue }
  }
  
  var second: U {
    get { rawValue.1 }
    set { rawValue.1 = newValue }
  }
}
