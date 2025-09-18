import Foundation
import IOReader

/// 二つの値を、辞書のキーやHeapの要素にする際に用いる、ラッパーオブジェクトです
///
///
/// ```swift
/// var m: [Pack2<Int,Int>: Int] = [:]
/// m[.init(10, 100), default: 0] += 1
/// ```
///
/// ```swift
/// var heap: Heap<Pack2<Int,Int>> = []
/// heap.insert(.init(1,2))
/// ```
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

extension Pack2: Hashable where T: Hashable, U: Hashable {
  
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
}
