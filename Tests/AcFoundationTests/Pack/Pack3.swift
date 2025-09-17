import Foundation
import IOReader

public struct Pack3<T,U,V> {
  
  public typealias RawValue = (T,U,V)

  public var rawValue: RawValue
  
  @inlinable
  @inline(__always)
  public init(_ t: T,_ u: U,_ v: V) {
    self.rawValue = (t,u,v)
  }
  
  @inlinable
  @inline(__always)
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Pack3: Equatable where T: Equatable, U: Equatable, V: Equatable {
  
  @inlinable
  @inline(__always)
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension Pack3: Comparable where T: Comparable, U: Comparable, V: Comparable {
  
  @inlinable
  @inline(__always)
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Pack3: Hashable where repeat T: Hashable, U: Hashable, V: Hashable {
  
  @inlinable
  @inline(__always)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue.0)
    hasher.combine(rawValue.1)
    hasher.combine(rawValue.2)
  }
}

extension Pack3: SingleReadable where T: SingleReadable, U: SingleReadable, V: SingleReadable {
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Self {
    .init(try .read(), try .read(), try .read())
  }
}

extension Pack3: Sendable where T: Sendable, U: Sendable, V: Sendable { }

extension Pack3 {
  
  var first: T {
    get { rawValue.0 }
    set { rawValue.0 = newValue }
  }
  
  var second: U {
    get { rawValue.1 }
    set { rawValue.1 = newValue }
  }
  
  var third: V {
    get { rawValue.2 }
    set { rawValue.2 = newValue }
  }
}
