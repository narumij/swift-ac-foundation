import IOStream

extension String {

  @inlinable
  public static var stdin: String {
    try! read()
  }
}
