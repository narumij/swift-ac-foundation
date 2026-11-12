import IOStream

extension String {

  public static func readLine() -> String {
    Swift.readLine()!
  }

  public static func stdin(columns: Int) -> String {
    try! _atos.read(count: columns)
  }
}

extension Array where Element == String {

  public static func stdin(rows: Int) -> [String] {
    (0..<rows).map { _ in .readLine() }
  }

  public static func stdin(rows: Int, columns: Int) -> [String] {
    (0..<rows).map { _ in .stdin(columns: columns) }
  }
}

extension String {

  public static var stdin: String {
    try! _atos.read()
  }
}

extension Array where Element == String {

  public static func stdin() -> [String] {
    Array(makeLineIterator(_atos.read))
  }

  public static func stdin(columns: Int) -> [String] {
    (0..<columns).map { _ in .stdin }
  }
}
