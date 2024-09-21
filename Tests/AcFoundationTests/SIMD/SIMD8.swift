import Foundation

public struct SIMD8<Scalar: SIMDScalar> {
  @inlinable
  init(
    v0: Scalar, v1: Scalar, v2: Scalar, v3: Scalar,
    v4: Scalar, v5: Scalar, v6: Scalar, v7: Scalar
  ) {
    (
      self.v0, self.v1, self.v2, self.v3,
      self.v4, self.v5, self.v6, self.v7
    ) = (
      v0, v1, v2, v3,
      v4, v5, v6, v7
    )
  }
  @usableFromInline
  var v0, v1, v2, v3, v4, v5, v6, v7: Scalar
}
extension SIMD8: Codable where Scalar: SIMDScalar {}
extension SIMD8: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
  @inlinable
  public init() {
    (v0, v1, v2, v3, v4, v5, v6, v7) =
      (.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero)
  }
}
extension SIMD8: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
  public typealias MaskStorage = SIMD4<Scalar.SIMDMaskScalar>
  @inlinable
  public subscript(index: Int) -> Scalar {
    @inline(__always) get {
      switch index {
      case 0: return v0
      case 1: return v1
      case 2: return v2
      case 3: return v3
      case 4: return v4
      case 5: return v5
      case 6: return v6
      case 7: return v7
      default: fatalError()
      }
    }
    set(newValue) {
      switch index {
      case 0: v0 = newValue
      case 1: v1 = newValue
      case 2: v2 = newValue
      case 3: v3 = newValue
      case 4: v4 = newValue
      case 5: v5 = newValue
      case 6: v6 = newValue
      case 7: v7 = newValue
      default: fatalError()
      }
    }
  }
  @inlinable
  public var scalarCount: Int { 8 }
}
extension SIMD8: Equatable where Scalar: Equatable {}
extension SIMD8: Hashable where Scalar: Hashable {}
extension SIMD8: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Scalar...) {
    (v0, v1, v2, v3, v4, v5, v6, v7) =
      (
        elements[0], elements[1], elements[2], elements[3],
        elements[4], elements[5], elements[6], elements[7]
      )
  }
}
extension SIMD8: CustomStringConvertible {
  @inlinable
  public var description: String {
    [v0, v1, v2, v3, v4, v5, v6, v7].description
  }
}
