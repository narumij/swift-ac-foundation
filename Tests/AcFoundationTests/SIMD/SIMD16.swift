import Foundation

public struct SIMD16<Scalar: SIMDScalar> {
  @inlinable
  init(
    v0: Scalar, v1: Scalar, v2: Scalar, v3: Scalar,
    v4: Scalar, v5: Scalar, v6: Scalar, v7: Scalar,
    v8: Scalar, v9: Scalar, v10: Scalar, v11: Scalar,
    v12: Scalar, v13: Scalar, v14: Scalar, v15: Scalar
  ) {
    (
      self.v0, self.v1, self.v2, self.v3,
      self.v4, self.v5, self.v6, self.v7,
      self.v8, self.v9, self.v10, self.v11,
      self.v12, self.v13, self.v14, self.v15
    ) = (
      v0, v1, v2, v3,
      v4, v5, v6, v7,
      v8, v9, v10, v11,
      v12, v13, v14, v15
    )
  }
  @usableFromInline
  var v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: Scalar
}
extension SIMD16: Codable where Scalar: SIMDScalar {}
extension SIMD16: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
  @inlinable
  public init() {
    (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) =
      (
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero
      )
  }
}
extension SIMD16: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
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
      case 8: return v8
      case 9: return v9
      case 10: return v10
      case 11: return v11
      case 12: return v12
      case 13: return v13
      case 14: return v14
      case 15: return v15
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
      case 8: v8 = newValue
      case 9: v9 = newValue
      case 10: v10 = newValue
      case 11: v11 = newValue
      case 12: v12 = newValue
      case 13: v13 = newValue
      case 14: v14 = newValue
      case 15: v15 = newValue
      default: fatalError()
      }
    }
  }
  @inlinable
  public var scalarCount: Int { 16 }
}
extension SIMD16: Equatable where Scalar: Equatable {}
extension SIMD16: Hashable where Scalar: Hashable {}
extension SIMD16: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Scalar...) {
    (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) =
      (
        elements[0], elements[1], elements[2], elements[3],
        elements[4], elements[5], elements[6], elements[7],
        elements[8], elements[9], elements[10], elements[11],
        elements[12], elements[13], elements[14], elements[15]
      )
  }
}
extension SIMD16: CustomStringConvertible {
  @inlinable
  public var description: String {
    [
      v0, v1, v2, v3, v4, v5, v6, v7,
      v8, v9, v10, v11, v12, v13, v14, v15,
    ].description
  }
}
