import IOReader

@available(macOS 26.0, *)
extension InlineArray: SingleReadable where Element: SingleReadable {
  public static func read() throws -> Self {
    try .init { _ in try Element.read() }
  }
}
