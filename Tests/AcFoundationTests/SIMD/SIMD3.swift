import Foundation

extension SIMD3 where Scalar: FixedWidthInteger {
  @inlinable
  func sum() -> Scalar { x + y + z }
}
@inlinable
func dot<Scalar>(_ lhs: SIMD3<Scalar>, _ rhs: SIMD3<Scalar>) -> Scalar
where Scalar: FixedWidthInteger {
  (lhs &* rhs).sum()
}
@inlinable
func dot<Scalar>(_ lhs: SIMD3<Scalar>, _ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FloatingPoint {
  (lhs * rhs).sum()
}
@inlinable
func length_squared<Scalar>(_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
  dot(rhs, rhs)
}
@inlinable
func length_squared<Scalar>(_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FloatingPoint {
  dot(rhs, rhs)
}
@inlinable
func distance_squared<Scalar>(_ lhs: SIMD3<Scalar>, _ rhs: SIMD3<Scalar>) -> Scalar
where Scalar: FixedWidthInteger {
  length_squared(lhs &- rhs)
}
@inlinable
func distance_squared<Scalar>(_ lhs: SIMD3<Scalar>, _ rhs: SIMD3<Scalar>) -> Scalar
where Scalar: FloatingPoint {
  length_squared(lhs - rhs)
}

@inlinable
func min<T: Comparable>(_ a: SIMD3<T>, _ b: SIMD3<T>) -> SIMD3<T> {
  .init(min(a.x, b.x), min(a.y, b.y), min(a.z, b.z))
}

@inlinable
func max<T: Comparable>(_ a: SIMD3<T>, _ b: SIMD3<T>) -> SIMD3<T> {
  .init(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z))
}
