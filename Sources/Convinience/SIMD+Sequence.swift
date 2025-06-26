// SIMDでシーケンスプロトコルの諸々を使う

public struct SIMDIterator<S>: IteratorProtocol where S: SIMD {
  let simd: S
  var index: Int = 0
  public mutating func next() -> S.Scalar? {
    guard index < S.scalarCount else { return nil }
    defer { index += 1 }
    return simd[index]
  }
}

extension SIMD2: @retroactive Sequence {

  public func makeIterator() -> SIMDIterator<Self> {
    .init(simd: self)
  }
}

extension SIMD3: @retroactive Sequence {

  public func makeIterator() -> SIMDIterator<Self> {
    .init(simd: self)
  }
}

extension SIMD4: @retroactive Sequence {

  public func makeIterator() -> SIMDIterator<Self> {
    .init(simd: self)
  }
}
