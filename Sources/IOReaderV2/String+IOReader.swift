import IOStream

extension String {

  @inlinable
  public static var stdin: String {
    try! read()
  }

  @inlinable
  public static func stdin(columns: Int) -> String {
    try! read(columns: columns)
  }
}

extension Array where Element == String {

  @inlinable
  public static func stdin(columns: Int) -> [String] {
    (0..<columns).map { _ in .stdin }
  }

  @inlinable
  public static func stdin(rows: Int, columns: Int) -> [String] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}
