@inlinable
@inline(__always)
func integerDigit(_ c: UInt8, radix: Int) -> UInt8? {
  let digit: UInt8
  switch c {
  case UInt8(ascii: "0")...UInt8(ascii: "9"):
    digit = c - UInt8(ascii: "0")
  case UInt8(ascii: "a")...UInt8(ascii: "f"):
    digit = c - UInt8(ascii: "a") + 10
  case UInt8(ascii: "A")...UInt8(ascii: "F"):
    digit = c - UInt8(ascii: "A") + 10
  default:
    return nil
  }
  return digit < radix ? digit : nil
}
