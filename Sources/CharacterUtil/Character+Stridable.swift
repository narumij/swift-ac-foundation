// MARK: - Character Convinience

extension Character: @retroactive Strideable {
  
  public func distance(to other: Character) -> Int {
    guard let a = asciiValue, let b = other.asciiValue else {
      fatalError("Character must be an ASCII character.")
    }
    return Int(b) - Int(a)
  }
  
  public func advanced(by n: Int) -> Character {
    guard let a = asciiValue else {
      fatalError("Character must be an ASCII character.")
    }
    return Character(UnicodeScalar(UInt8(Int(a) + n)))
  }
}
