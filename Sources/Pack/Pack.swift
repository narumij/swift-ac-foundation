import Foundation
import IOReader

/// 複数の値を、辞書のキーやHeapの要素にする際に用いる、ラッパーオブジェクトです
///
///
/// ```swift
/// var m: [Pack<Int,Int>: Int] = [:]
/// m[.init(10, 100), default: 0] += 1
/// ```
///
/// ```swift
/// var heap: Heap<Pack<Int,Int,Int>> = []
/// heap.insert(.init(1,2,3))
/// ```
///
/// コンパイラが許す限りの要素数が使えます。
///
/// 他にPack2やPack3があります。コンパイルに問題が生じた場合はそちらをお試しください。
public struct Pack<each T> {
  
  public typealias RawValue = (repeat each T)

  public var rawValue: RawValue
  
  @inlinable
  @inline(__always)
  public init(_ values: repeat each T) {
    self.rawValue = (repeat each values)
  }
  
  @inlinable
  @inline(__always)
  public init(rawValue: (repeat each T)) {
    self.rawValue = (repeat each rawValue)
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

extension Pack: CustomStringConvertible {
  public var description: String {
    func type<V>(_ value: V) -> String {
      "\(V.self)"
    }
    func describe<V>(_ value: V) -> String {
      String(describing: value)
    }
    var types: [String] = []
    for t in repeat type(each rawValue) {
      types.append(t)
    }
    var values: [String] = []
    for d in repeat describe(each rawValue) {
      values.append(d)
    }
    return "Pack<\(types.joined(separator: ", "))>(\(values.joined(separator: ", ")))"
  }
}

extension Pack: CustomDebugStringConvertible {
  public var debugDescription: String { description }
}

extension Pack: SingleReadable where repeat each T: SingleReadable {
  
  @inlinable
  @inline(__always)
  public static func read() throws -> Pack<repeat each T> {
    .init(repeat try (each T).read())
  }
}

extension Pack: Sendable where repeat each T: Sendable { }
