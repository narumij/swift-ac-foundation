import Foundation

infix operator ..<= : RangeFormationPrecedence

/// ...演算子は右辺が左辺より小さいと範囲チェックで落ちるので、その代替に使います。
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
