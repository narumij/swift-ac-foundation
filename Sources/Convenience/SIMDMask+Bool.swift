extension SIMDMask {
  
  /// SIMDで比較演算した結果が全部真
  @inlinable
  @inline(__always)
  public var all: Bool {
    for i in 0..<scalarCount {
      if !self[i] {
        return false
      }
    }
    return true
  }

  /// SIMDで比較演算した結果がどれか真
  @inlinable
  @inline(__always)
  public var any: Bool {
    for i in 0..<scalarCount {
      if self[i] {
        return true
      }
    }
    return false
  }
}
