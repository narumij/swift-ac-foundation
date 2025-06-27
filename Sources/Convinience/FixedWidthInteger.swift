extension FixedWidthInteger {
  
  /// 0からNの半開区間
  ///
  /// pythonでよく見かけて便利そうだったので中途半端な真似のまま追加
  @inlinable
  public var range: Range<Self> { 0..<self }
  
  /// N回繰り返す
  ///
  /// c++でよく見かけて便利そうだったので追加
  @inlinable
  @discardableResult
  public func rep<T>(_ f: () throws -> T) rethrows -> [T] {
    try (0..<self).map { _ in try f() }
  }
  
  /// N回繰り返す
  ///
  /// c++でよく見かけて便利そうだったので追加
  @inlinable
  @discardableResult
  public func rep<T>(_ f: (Self) throws -> T) rethrows -> [T] {
    try (0..<self).map { i in try f(i) }
  }
}
