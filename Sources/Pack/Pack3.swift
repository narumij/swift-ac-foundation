import Foundation
import IOReader

// どうぞご自由にお使いください。

@frozen
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

extension Pack3: Hashable where T: Hashable, U: Hashable, V: Hashable {
  
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
  
  @inlinable
  public var first: T {
    @inline(__always) _read { yield rawValue.0 }
    @inline(__always) _modify { yield &rawValue.0 }
  }
  
  @inlinable
  public var second: U {
    @inline(__always) _read { yield rawValue.1 }
    @inline(__always) _modify { yield &rawValue.1 }
  }
  
  @inlinable
  public var third: V {
    @inline(__always) _read { yield rawValue.2 }
    @inline(__always) _modify { yield &rawValue.2 }
  }
}
