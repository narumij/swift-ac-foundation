import Algorithms
import Foundation

// MARK: - Vector

extension SIMD2 where Scalar: FixedWidthInteger {
  @inlinable
  func sum() -> Scalar { x + y }
}
@inlinable
func dot<Scalar>(_ lhs: SIMD2<Scalar>, _ rhs: SIMD2<Scalar>) -> Scalar
where Scalar: FixedWidthInteger {
  (lhs &* rhs).sum()
}
@inlinable
func dot<Scalar>(_ lhs: SIMD2<Scalar>, _ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FloatingPoint {
  (lhs * rhs).sum()
}
@inlinable
func length_squared<Scalar>(_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
  dot(rhs, rhs)
}
@inlinable
func length_squared<Scalar>(_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FloatingPoint {
  dot(rhs, rhs)
}
@inlinable
func distance_squared<Scalar>(_ lhs: SIMD2<Scalar>, _ rhs: SIMD2<Scalar>) -> Scalar
where Scalar: FixedWidthInteger {
  length_squared(lhs &- rhs)
}
@inlinable
func distance_squared<Scalar>(_ lhs: SIMD2<Scalar>, _ rhs: SIMD2<Scalar>) -> Scalar
where Scalar: FloatingPoint {
  length_squared(lhs - rhs)
}

@inlinable
func triangle_area<Scalar>(_ a: SIMD2<Scalar>, _ b: SIMD2<Scalar>, _ c: SIMD2<Scalar>) -> Scalar
where Scalar: Numeric {
  (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)
}

@inlinable
func min<T: Comparable>(_ a: SIMD2<T>, _ b: SIMD2<T>) -> SIMD2<T> {
  .init(min(a.x, b.x), min(a.y, b.y))
}

@inlinable
func max<T: Comparable>(_ a: SIMD2<T>, _ b: SIMD2<T>) -> SIMD2<T> {
  .init(max(a.x, b.x), max(a.y, b.y))
}

extension SIMD2 where Scalar == Int {
  //　Z-UP 右ネジ
  @inlinable
  static var rotate90: [Self] { [[0, -1], [1, 0]] }
  @inlinable
  static var rotate180: [Self] { [[-1, 0], [0, -1]] }
  @inlinable
  static var rotate270: [Self] { [[0, 1], [-1, 0]] }
}

extension SIMD2 where Scalar == Int {
  public enum MoveDirection: String {
    case D
    case U
    case L
    case R
  }
  @inlinable
  static func move(_ d: MoveDirection) -> Self {
    switch d {
    case .D:
      return [1, 0]
    case .U:
      return [-1, 0]
    case .L:
      return [0, -1]
    case .R:
      return [0, 1]
    }
  }
  @inlinable
  static func move(_ d: UInt8) -> Self {
    move(.init(rawValue: String(bytes: [d], encoding: .ascii)!)!)
  }
}

@inlinable
func mul<Scalar>(_ m: [[Scalar]], _ v: SIMD2<Scalar>) -> SIMD2<Scalar>
where Scalar: FixedWidthInteger {
  // 行列がcolumn-majorなのかrow-majorなのか、いまいちわかっていない。
  // たまたまあってるレベル
  [(SIMD2(m[0]) &* v).sum(), (SIMD2(m[1]) &* v).sum()]
}

@inlinable
func &* <Component>(lhs: [[Component]], rhs: SIMD2<Component>) -> SIMD2<Component>
where Component: FixedWidthInteger {
  mul(lhs, rhs)
}

@inlinable
func product(origin o: SIMD2<Int>, size s: SIMD2<Int>) -> [SIMD2<Int>] {
  product(o.x..<(o.x + s.x), o.y..<(o.y + s.y)).map { SIMD2<Int>(x: $0.0, y: $0.1) }
}

extension SIMD2 {
  @inlinable
  func reversed() -> Self { .init(y, x) }
}

@inlinable
func manhattanDistance<T>(_ lhs: SIMD2<T>, _ rhs: SIMD2<T>) -> T
where T: SignedNumeric, T: Comparable {
  (0..<SIMD2<Int>.scalarCount).reduce(0) { $0 + abs(lhs[$1] - rhs[$1]) }
}
