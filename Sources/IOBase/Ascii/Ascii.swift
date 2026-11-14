extension FixedWidthInteger {
  @inlinable @inline(__always) static var NULL: Self { 0x00 }
  @inlinable @inline(__always) static var HT: Self { 0x09 }
  @inlinable @inline(__always) static var LF: Self { 0x0A }
  @inlinable @inline(__always) static var VT: Self { 0x0B }
  @inlinable @inline(__always) static var FF: Self { 0x0C }
  @inlinable @inline(__always) static var CR: Self { 0x0D }
  @inlinable @inline(__always) static var SP: Self { 0x20 }

  @inlinable @inline(__always) static var PLUS: Self { 0x2B }
  @inlinable @inline(__always) static var MINUS: Self { 0x2D }
  @inlinable @inline(__always) static var ZERO: Self { 0x30 }
}

@usableFromInline
let spaces: UInt =
  1 << UInt.HT | 1 << UInt.LF | 1 << UInt.VT | 1 << UInt.FF | 1 << UInt.CR | 1 << UInt.SP

@usableFromInline
let newlines: UInt = 1 << UInt.LF | 1 << UInt.CR

@inlinable
@inline(__always)
func isASCIINewline<T: FixedWidthInteger>(_ c: T) -> Bool {
  (1 << c) & newlines != 0
}

@inlinable
@inline(__always)
package func isNilOrAsciiNewLine<T: FixedWidthInteger>(_ c: T?) -> Bool {
  guard let c else { return true }
  return isASCIINewline(c)
}

@inlinable
package func describeByte(_ c: UInt8?) -> String {
  c.map { String(UnicodeScalar($0)).debugDescription } ?? "EOF"
}

@inlinable
@inline(__always)
func isNumber<T: FixedWidthInteger>(_ c: T) -> Bool {
  c >= .ZERO && c <= .ZERO + 9
}

@inlinable
@inline(__always)
package func isASCIIWhitespace<T: FixedWidthInteger>(_ c: T) -> Bool {
  (1 << c) & spaces != 0
}
