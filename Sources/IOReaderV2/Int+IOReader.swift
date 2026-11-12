import IOStream

extension Int {

  @inlinable
  public static var stdin: Int {
    try! read()
  }
}
