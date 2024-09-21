import Foundation

public struct SIMD4<Scalar: SIMDScalar> {
  @inlinable
  init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
    (self.x, self.y, self.z, self.w) = (x, y, z, w)
  }
  @inlinable
  init(_ x: Scalar, _ y: Scalar, _ z: Scalar, _ w: Scalar) {
    (self.x, self.y, self.z, self.w) = (x, y, z, w)
  }
  @usableFromInline
  var x, y, z, w: Scalar
}
extension SIMD4: Codable where Scalar: SIMDScalar {}
extension SIMD4: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
  @inlinable
  public init() {
    (x, y, z, w) = (.zero, .zero, .zero, .zero)
  }
}
extension SIMD4: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
  public typealias MaskStorage = SIMD4<Scalar.SIMDMaskScalar>
  @inlinable
  public subscript(index: Int) -> Scalar {
    @inline(__always) get {
      switch index {
      case 0: return x
      case 1: return y
      case 2: return z
      case 3: return w
      default: fatalError()
      }
    }
    set(newValue) {
      switch index {
      case 0: x = newValue
      case 1: y = newValue
      case 2: z = newValue
      case 3: w = newValue
      default: fatalError()
      }
    }
  }
  @inlinable
  public var scalarCount: Int { 4 }
}
extension SIMD4: Equatable where Scalar: Equatable {}
extension SIMD4: Hashable where Scalar: Hashable {}
extension SIMD4: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Scalar...) {
    (x, y, z, w) = (elements[0], elements[1], elements[2], elements[3])
  }
}
extension SIMD4: CustomStringConvertible {
  @inlinable
  public var description: String { [x, y, z, w].description }
}
