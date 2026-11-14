@frozen
public struct Pack4<T, U, V, W> {

  public typealias RawValue = (T, U, V, W)

  public var rawValue: RawValue

  @inlinable
  public init(_ t: T, _ u: U, _ v: V, _ w: W) {
    self.rawValue = (t, u, v, w)
  }

  @inlinable
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Pack4: Equatable where T: Equatable, U: Equatable, V: Equatable, W: Equatable {

  @inlinable
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension Pack4: Comparable where T: Comparable, U: Comparable, V: Comparable, W: Comparable {

  @inlinable
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Pack4: Hashable where T: Hashable, U: Hashable, V: Hashable, W: Hashable {

  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue.0)
    hasher.combine(rawValue.1)
    hasher.combine(rawValue.2)
    hasher.combine(rawValue.3)
  }
}

extension Pack4: Sendable where T: Sendable, U: Sendable, V: Sendable, W: Sendable {}

extension Pack4 {

  @inlinable
  public var first: T {
    _read { yield rawValue.0 }
    _modify { yield &rawValue.0 }
  }

  @inlinable
  public var second: U {
    _read { yield rawValue.1 }
    _modify { yield &rawValue.1 }
  }

  @inlinable
  public var third: V {
    _read { yield rawValue.2 }
    _modify { yield &rawValue.2 }
  }

  @inlinable
  public var fourth: W {
    _read { yield rawValue.3 }
    _modify { yield &rawValue.3 }
  }
}
