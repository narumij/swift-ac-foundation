extension UInt8 {
  
  /// ASCII の小文字 a–z かどうか
  @inlinable
  @inline(__always)
  public var isLowercase: Bool {
    // 'a'…'z' == 0x61…0x7A
    return (0x61...0x7A).contains(self)
  }
  
  @inlinable
  @inline(__always)
  public func lowercased() -> Self {
    return isUppercase
      ? self + 0x20
      : self
  }
  
  /// ASCII の大文字 A–Z かどうか
  @inlinable
  @inline(__always)
  public var isUppercase: Bool {
    // 'A'…'Z' == 0x41…0x5A
    return (0x41...0x5A).contains(self)
  }
  
  @inlinable
  @inline(__always)
  public func uppercased() -> Self {
    // 0x61...0x7A が 'a'…'z'
    return isLowercase
      ? self - 0x20
      : self
  }
}

extension UInt8 {
  
  /// ASCII および NEL を空白とみなす
  @inlinable
  @inline(__always)
  public var isWhitespace: Bool {
    switch self {
    case 0x09...0x0D,  // HT, LF, VT, FF, CR
         0x20,        // Space
         0x85:        // NEXT LINE (NEL)
      return true
    default:
      return false
    }
  }

  // SwiftのCharacterProperties.swiftを一部流用しています
  @inlinable
  @inline(__always)
  public var isNewline: Bool {
    switch self {
      case 0x000A...0x000D /* LF ... CR */: return true
      case 0x0085 /* NEXT LINE (NEL) */: return true
      default: return false
    }
  }

  // SwiftのCharacterProperties.swiftを一部流用しています
  @inlinable
  @inline(__always)
  public var isWholeNumber: Bool {
    return wholeNumberValue != nil
  }
  
  // SwiftのCharacterProperties.swiftを一部流用しています
  @inlinable
  @inline(__always)
  public var wholeNumberValue: Int? {
    switch self {
    // DIGIT ZERO..DIGIT NINE
    case 0x0030...0x0039: return Int(self &- 0x0030)
    default: return nil
    }
  }
  
  // SwiftのCharacterProperties.swiftを一部流用しています
  @inlinable
  @inline(__always)
  public var isHexDigit: Bool {
    return hexDigitValue != nil
  }
  
  // SwiftのCharacterProperties.swiftを一部流用しています
  @inlinable
  @inline(__always)
  public var hexDigitValue: Int? {
    switch self {
    // DIGIT ZERO..DIGIT NINE
    case 0x0030...0x0039: return Int(self &- 0x0030)
    // LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER F
    case 0x0041...0x0046: return Int((self &+ 10) &- 0x0041)
    // LATIN SMALL LETTER A..LATIN SMALL LETTER F
    case 0x0061...0x0066: return Int((self &+ 10) &- 0x0061)
    default: return nil
    }
  }
}
