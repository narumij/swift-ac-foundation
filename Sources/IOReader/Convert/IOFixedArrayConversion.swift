public protocol IOFixedArrayConversion {
  associatedtype Element: Component
  static var columns: Int { get }
  static func read(_ elements: ColumnsIterator<Element>) -> Self
}

extension IOFixedArrayConversion {

  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    (read(ColumnsIterator(columns: columns) { try Element.read() }), nil)
  }
}
