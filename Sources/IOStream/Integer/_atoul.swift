@preconcurrency import _FastIO

@usableFromInline
struct _atoul<Element: FixedWidthInteger & UnsignedInteger>: StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try read() as (value: Element, separator: UInt8))
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> (value: Element, separator: UInt8) {
    switch _fastio_integer_mode {
    case FastIOIntegerAuto:
      return try _atoulAuto.read()
    case FastIOIntegerAuto2:
      return try _atoulAuto2.read()
    case FastIOIntegerBinary:
      return try _atoul2.read()
    case FastIOIntegerOctal:
      return try _atoul8.read()
    case FastIOIntegerDecimal:
      return try _atoul10.read()
    case FastIOIntegerHexadecimal:
      return try _atoul16.read()
    default:
      fatalError("Integer input mode is not implemented")
    }
  }
}

extension _atoul {

  @usableFromInline
  struct _atoul2: ZeroBufferIOReader2, StaticIOSubReader {}

  @usableFromInline
  struct _atoul8: ZeroBufferIOReader8, StaticIOSubReader {}

  @usableFromInline
  struct _atoul10: ZeroBufferIOReader, StaticIOSubReader {}

  @usableFromInline
  struct _atoul16: ZeroBufferIOReader16, StaticIOSubReader {}

  @usableFromInline
  struct _atoulAuto: ZeroBufferIOReaderAuto, StaticIOSubReader {}

  @usableFromInline
  struct _atoulAuto2: ZeroBufferIOReaderAuto2, StaticIOSubReader {}
}
