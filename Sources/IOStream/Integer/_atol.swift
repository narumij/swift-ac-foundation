@preconcurrency import _FastIO

@usableFromInline
struct _atol<Element: FixedWidthInteger & SignedInteger>: StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try read(integerMode: IntegerMode(rawValue: _fastio_integer_mode.rawValue)!)
  }

  @inlinable
  @inline(__always)
  public static func read(integerMode: IntegerMode) throws -> Item {
    switch integerMode {
    case .auto:
      try _atolAuto.read()
    case .auto2:
      try _atolAuto2.read()
    case .binary:
      try _atol2.read()
    case .octal:
      try _atol8.read()
    case .decimal:
      try _atol10.read()
    case .hexadecimal:
      try _atol16.read()
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
