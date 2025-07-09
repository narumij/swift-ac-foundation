// SIMDでシーケンスプロトコルの諸々を使う

public struct SIMDIterator<S>: IteratorProtocol where S: SIMD {
  
  @inlinable
  @inline(__always)
  public init(simd: S, index: Int = 0) {
    self.simd = simd
    self.index = index
  }
  
  @usableFromInline let simd: S
  @usableFromInline var index: Int = 0
  
  @inlinable
  @inline(__always)
  public mutating func next() -> S.Scalar? {
    guard index < S.scalarCount else { return nil }
    defer { index += 1 }
    return simd[index]
  }
}

extension SIMD2: @retroactive Sequence {

  @inlinable
  @inline(__always)
  public func makeIterator() -> SIMDIterator<Self> {
    .init(simd: self)
  }
}

extension SIMD3: @retroactive Sequence {

  @inlinable
  @inline(__always)
  public func makeIterator() -> SIMDIterator<Self> {
    .init(simd: self)
  }
}

extension SIMD4: @retroactive Sequence {

  @inlinable
  @inline(__always)
  public func makeIterator() -> SIMDIterator<Self> {
    .init(simd: self)
  }
}
