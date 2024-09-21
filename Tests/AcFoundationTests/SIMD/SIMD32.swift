import Foundation

public struct SIMD32<Scalar: SIMDScalar> {
  @inlinable
  init(
    v0: Scalar, v1: Scalar, v2: Scalar, v3: Scalar,
    v4: Scalar, v5: Scalar, v6: Scalar, v7: Scalar,
    v8: Scalar, v9: Scalar, v10: Scalar, v11: Scalar,
    v12: Scalar, v13: Scalar, v14: Scalar, v15: Scalar,
    v16: Scalar, v17: Scalar, v18: Scalar, v19: Scalar,
    v20: Scalar, v21: Scalar, v22: Scalar, v23: Scalar,
    v24: Scalar, v25: Scalar, v26: Scalar, v27: Scalar,
    v28: Scalar, v29: Scalar, v30: Scalar, v31: Scalar
  ) {
      (
        self.v0, self.v1, self.v2, self.v3,
        self.v4, self.v5, self.v6, self.v7,
        self.v8, self.v9, self.v10, self.v11,
        self.v12, self.v13, self.v14, self.v15,
        self.v16, self.v17, self.v18, self.v19,
        self.v20, self.v21, self.v22, self.v23,
        self.v24, self.v25, self.v26, self.v27,
        self.v28, self.v29, self.v30, self.v31
      ) = (
        v0, v1, v2, v3,
        v4, v5, v6, v7,
        v8, v9, v10, v11,
        v12, v13, v14, v15,
        v16, v17, v18, v19,
        v20, v21, v22, v23,
        v24, v25, v26, v27,
        v28, v29, v30, v31
      )
  }
  @usableFromInline
  var v0, v1, v2, v3, v4, v5, v6, v7,
    v8, v9, v10, v11, v12, v13, v14, v15,
    v16, v17, v18, v19, v20, v21, v22, v23,
    v24, v25, v26, v27, v28, v29, v30, v31: Scalar
}
extension SIMD32: Codable where Scalar: SIMDScalar {}
extension SIMD32: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
  @inlinable
  public init() {
    (
      v0, v1, v2, v3, v4, v5, v6, v7,
      v8, v9, v10, v11, v12, v13, v14, v15,
      v16, v17, v18, v19, v20, v21, v22, v23,
      v24, v25, v26, v27, v28, v29, v30, v31
    ) =
      (
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero
      )
  }
}
extension SIMD32: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
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
      case 16: return v16
      case 17: return v17
      case 18: return v18
      case 19: return v19
      case 20: return v20
      case 21: return v21
      case 22: return v22
      case 23: return v23
      case 24: return v24
      case 25: return v25
      case 26: return v26
      case 27: return v27
      case 28: return v28
      case 29: return v29
      case 30: return v30
      case 31: return v31
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
      case 16: v16 = newValue
      case 17: v17 = newValue
      case 18: v18 = newValue
      case 19: v19 = newValue
      case 20: v20 = newValue
      case 21: v21 = newValue
      case 22: v22 = newValue
      case 23: v23 = newValue
      case 24: v24 = newValue
      case 25: v25 = newValue
      case 26: v26 = newValue
      case 27: v27 = newValue
      case 28: v28 = newValue
      case 29: v29 = newValue
      case 30: v30 = newValue
      case 31: v31 = newValue
      default: fatalError()
      }
    }
  }
  @inlinable
  public var scalarCount: Int { 32 }
}
extension SIMD32: Equatable where Scalar: Equatable {}
extension SIMD32: Hashable where Scalar: Hashable {}
extension SIMD32: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Scalar...) {
    (
        v0, v1, v2, v3, v4, v5, v6, v7,
        v8, v9, v10, v11, v12, v13, v14, v15,
        v16, v17, v18, v19, v20, v21, v22, v23,
        v24, v25, v26, v27, v28, v29, v30, v31
    ) =
      (
        elements[0], elements[1], elements[2], elements[3],
        elements[4], elements[5], elements[6], elements[7],
        elements[8], elements[9], elements[10], elements[11],
        elements[12], elements[13], elements[14], elements[15],
        elements[16], elements[17], elements[18], elements[19],
        elements[20], elements[21], elements[22], elements[23],
        elements[24], elements[25], elements[26], elements[27],
        elements[28], elements[29], elements[30], elements[31]
      )
  }
}
extension SIMD32: CustomStringConvertible {
  @inlinable
  public var description: String {
    [
        v0, v1, v2, v3, v4, v5, v6, v7,
        v8, v9, v10, v11, v12, v13, v14, v15,
        v16, v17, v18, v19, v20, v21, v22, v23,
        v24, v25, v26, v27, v28, v29, v30, v31
    ].description
  }
}
