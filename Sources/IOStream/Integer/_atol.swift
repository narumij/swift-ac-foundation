@preconcurrency import _FastIO

@usableFromInline
struct _atol<Element: FixedWidthInteger & SignedInteger>: StaticIOReader {

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
      return try _atolAuto.read()
    case FastIOIntegerAuto2:
      return try _atolAuto2.read()
    case FastIOIntegerBinary:
      return try _atol2.read()
    case FastIOIntegerOctal:
      return try _atol8.read()
    case FastIOIntegerDecimal:
      return try _atol10.read()
    case FastIOIntegerHexadecimal:
      return try _atol16.read()
    default:
      fatalError("Integer input mode is not implemented")
    }
  }
}

extension _atol {

  @usableFromInline
  struct _atol2: ZeroBufferIOReader2, StaticIOSubReader {}

  @usableFromInline
  struct _atol8: ZeroBufferIOReader8, StaticIOSubReader {}

  @usableFromInline
  struct _atol10: ZeroBufferIOReader, StaticIOSubReader {}

  @usableFromInline
  struct _atol16: ZeroBufferIOReader16, StaticIOSubReader {}

  @usableFromInline
  struct _atolAuto: ZeroBufferIOReaderAuto, StaticIOSubReader {}

  @usableFromInline
  struct _atolAuto2: ZeroBufferIOReaderAuto2, StaticIOSubReader {}
}
