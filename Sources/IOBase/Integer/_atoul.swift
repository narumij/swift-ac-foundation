@preconcurrency import _FastIO

@usableFromInline
package struct _atoul<Element: FixedWidthInteger & UnsignedInteger>: StaticIOReader {

  @inlinable
  @inline(__always)
  @available(*, deprecated)
  public static func read() throws -> Element {
    valuePreservingSeparator(try read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try read(mode: IntegerMode(rawValue: _fastio_integer_mode.rawValue)!)
  }

  @inlinable
  @inline(__always)
  public static func read(mode: IntegerMode) throws -> Item {
    switch mode {
    case .auto:
      try _atoulAuto.read()
    case .auto2:
      try _atoulAuto2.read()
    case .binary:
      try _atoul2.read()
    case .octal:
      try _atoul8.read()
    case .decimal:
      try _atoul10.read()
    case .hexadecimal:
      try _atoul16.read()
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
