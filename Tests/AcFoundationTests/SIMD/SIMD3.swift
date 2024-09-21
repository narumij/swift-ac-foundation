import Foundation

public struct SIMD3<Scalar: SIMDScalar> {

  @inlinable
  public init(x: Scalar, y: Scalar, z: Scalar) {
    (self.x, self.y, self.z) = (x, y, z)
  }
  @inlinable
  public init(_ x: Scalar, _ y: Scalar, _ z: Scalar) {
    (self.x, self.y, self.z) = (x, y, z)
  }
  @usableFromInline
  var x, y, z: Scalar
}
extension SIMD3: Codable where Scalar: SIMDScalar {}
extension SIMD3: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
  @inlinable
  public init() {
    (x, y, z) = (.zero, .zero, .zero)
  }
}
extension SIMD3: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
  public typealias MaskStorage = SIMD3<Scalar.SIMDMaskScalar>
  @inlinable
  public subscript(index: Int) -> Scalar {
    @inline(__always) get {
      switch index {
      case 0: return x
      case 1: return y
      case 2: return z
      default: fatalError()
      }
    }
    set(newValue) {
      switch index {
      case 0: x = newValue
      case 1: y = newValue
      case 2: z = newValue
      default: fatalError()
      }
    }
  }
  @inlinable
  public var scalarCount: Int { 3 }
}
extension SIMD3: Equatable where Scalar: Equatable {}
extension SIMD3: Hashable where Scalar: Hashable {}
extension SIMD3: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Scalar...) {
    (x, y, z) = (elements[0], elements[1], elements[2])
  }
}
extension SIMD3: CustomStringConvertible {
  @inlinable
  public var description: String { [x, y, z].description }
}

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
