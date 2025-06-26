extension Array {
  
  /// 初期値左辺で配列を作成する
  ///
  /// pythonでよく見かけて便利そうだったので追加
  @inlinable
  public static func * (lhs: Self, rhs: Int) -> Self {
    repeatElement(lhs, count: rhs).flatMap { $0 }
  }
  
  /// 初期値左辺で2次元配列を作成する
  @inlinable
  public static func * (lhs: Self, rhs: (A: Int, B: Int)) -> [Self] {
    [lhs * rhs.B] * rhs.A
  }
  
  /// 初期値左辺で3次元配列を作成する
  @inlinable
  public static func * (lhs: Self, rhs: (A: Int, B: Int, C: Int)) -> [[Self]] {
    [[lhs * rhs.C] * rhs.B] * rhs.A
  }
  
  /// 初期値左辺で4次元配列を作成する
  @inlinable
  public static func * (lhs: Self, rhs: (A: Int, B: Int, C: Int, D: Int)) -> [[[Self]]] {
    [[[lhs * rhs.D] * rhs.C] * rhs.B] * rhs.A
  }
}

extension String {

  /// 左辺を右辺分繰り返した文字列を作成する
  @inlinable
  public static func * (lhs: Self, rhs: Int) -> Self {
    repeatElement(lhs, count: rhs).joined()
  }
  
  /// 左辺を右辺分繰り返した文字列の配列を作成する
  @inlinable
  public static func * (lhs: Self, rhs: (A: Int, B: Int)) -> [Self] {
    [lhs * rhs.B] * rhs.A
  }
}
