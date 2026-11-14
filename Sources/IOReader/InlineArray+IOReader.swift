import IOBase

@available(macOS 26.0, *)
extension InlineArray: IOFixedArrayConversion, Group where Element: Component {

  @inlinable
  public static var columns: Int { count }

  @inlinable
  public static func read(_ elements: ColumnsIterator<Element>) -> Self {
    var elements = elements
    return Self { _ in elements.next()! }
  }
}
