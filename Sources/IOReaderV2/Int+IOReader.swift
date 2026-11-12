import IOStream

extension Int {

  @inlinable
  public static var stdin: Int {
    try! read()
  }
}

extension Array where Element == Int {

  @inlinable
  public static func stdin(rows: Int) -> [Int] {
    (0..<rows).map { _ in .stdin }
  }

  @inlinable
  public static func stdin(columns: Int) -> [Int] {
    (0..<columns).map { _ in .stdin }
  }
}

extension Array where Element == [Int] {

  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [[Int]] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}
