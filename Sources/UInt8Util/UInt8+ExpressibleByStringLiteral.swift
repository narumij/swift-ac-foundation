import Foundation

extension UInt8: @retroactive ExpressibleByStringLiteral {

  @inlinable
  public init(stringLiteral value: String) {
    precondition(
      value.count == 1,
      "UInt8(stringLiteral:) requires a single‐character literal")
    let ch = value.first!
    guard let ascii = ch.asciiValue else {
      fatalError("Character '\(ch)' is not ASCII; cannot initialize UInt8")
    }
    self = ascii
  }
}
