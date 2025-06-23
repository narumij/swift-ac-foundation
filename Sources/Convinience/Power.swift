import Foundation

precedencegroup PowerPrecedence {
  lowerThan: BitwiseShiftPrecedence
  higherThan: MultiplicationPrecedence
  associativity: right
  assignment: true
}

infix operator ** : PowerPrecedence

/// lhsのrhs乗
///
/// ```
/// 2 ** 3 // 8
/// ```
///
/// pythonでよく見かけて便利そうだったので追加
@inlinable
public func ** <INT>(lhs: INT, rhs: Int) -> INT where INT: FixedWidthInteger {
  repeatElement(lhs, count: rhs).product()
}

/// lhsのrhs乗
///
/// ```
/// 2 ** 3 // 8
/// ```
///
///
/// pythonでよく見かけて便利そうだったので追加
@inlinable
public func ** (lhs: Double, rhs: Double) -> Double { pow(lhs, rhs) }
