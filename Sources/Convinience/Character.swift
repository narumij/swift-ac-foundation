extension Sequence where Element == Character {
  
  /// 文字の配列をそのまま出力するものです
  ///
  /// printとString書くのすら面倒くさい気持ちの時に使えます
  ///
  /// 末尾に改行を添えます
  @inlinable
  public func write<Target>(to target: inout Target, terminator: Character? = "\n") where Target: TextOutputStream {
    forEach {
      $0.write(to: &target)
    }
    terminator?.write(to: &target)
  }
}
