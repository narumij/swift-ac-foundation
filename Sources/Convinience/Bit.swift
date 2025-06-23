extension FixedWidthInteger {
  /// 整数のビット読み書きを横着するものです
  @inlinable
  subscript(position: Int) -> Bool {
    get { self & (1 << position) != 0 }
    mutating set {
      if newValue {
        self = self | (1 << position)
      } else {
        self = self & ~(1 << position)
      }
    }
  }
}
