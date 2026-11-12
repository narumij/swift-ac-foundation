import IOStream

extension String {

  public static var stdin: String {
    try! read()
  }

  public static func stdin(columns: Int) -> String {
    try! read(columns: columns)
  }
}

extension Array where Element == String {

  public static func stdin(columns: Int) -> [String] {
    (0..<columns).map { _ in .stdin }
  }

  public static func stdin(rows: Int, columns: Int) -> [String] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}
