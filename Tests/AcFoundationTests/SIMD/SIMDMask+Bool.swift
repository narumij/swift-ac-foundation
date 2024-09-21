extension SIMDMask {
  @inlinable
  var all: Bool {
    for i in 0..<scalarCount {
      if !self[i] {
        return false
      }
    }
    return true
  }
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
