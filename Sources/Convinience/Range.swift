import Foundation

// MARK: - Range Convinience

infix operator ..<= : RangeFormationPrecedence

/// C++の写経をしているとき挙動の違いで...で落ちる場合に代替で使います
///
/// `for (int i = 0; i <= 10; ++i) { ... }`みたいなケースと同等です
@inlinable
public func ..<= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
  stride(from: lhs, through: rhs, by: 1)
}

infix operator ..>= : RangeFormationPrecedence

/// 降順で楽したい場合に
///
/// `for (int i = 10; i >= 0; --i) { ... }`みたいなケースと同等です
@inlinable
public func ..>= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
  stride(from: lhs, through: rhs, by: -1)
}

infix operator ..> : RangeFormationPrecedence

/// 降順で楽したい場合に
///
/// `for (int i = 10; i > 0; --i) { ... }`みたいなケースと同等です
@inlinable
public func ..> <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideTo<Bound> {
  stride(from: lhs, to: rhs, by: -1)
}
