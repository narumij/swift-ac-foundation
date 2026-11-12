import IOStream

extension Int {

  public static var stdin: Int {
    try! _atol<Int>.read()
  }
}

extension Array where Element == Int {

  public static func stdin() -> [Int] {
    Array(makeLineIterator(_atol<Int>.read))
  }

  public static func stdin(rows: Int) -> [Int] {
    (0..<rows).map { _ in .stdin }
  }

  public static func stdin(columns: Int) -> [Int] {
    (0..<columns).map { _ in .stdin }
  }
}

extension Array where Element == [Int] {

  public static func stdin(rows: Int, columns: Int) -> [[Int]] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}
