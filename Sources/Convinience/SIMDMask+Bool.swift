extension SIMDMask {
  
  /// SIMDで比較演算した結果が全部真
  @inlinable
  var all: Bool {
    for i in 0..<scalarCount {
      if !self[i] {
        return false
      }
    }
    return true
  }

  /// SIMDで比較演算した結果がどれか真
  @inlinable
  var any: Bool {
    for i in 0..<scalarCount {
      if self[i] {
        return true
      }
    }
    return false
  }
}
