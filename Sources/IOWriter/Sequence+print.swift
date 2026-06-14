import Foundation

extension Sequence where Element: BinaryInteger {

  /// 空白区切りで標準出力へ出力する
  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    var first = true
    forEach { element in
      if first {
        first = false
      } else {
        Swift.print(separator, terminator: "")
      }
      Swift.print(element, terminator: "")
    }
    Swift.print("", terminator: terminator)
  }
}

extension Sequence where Element: Sequence, Element.Element: BinaryInteger {

  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    forEach {
      $0.print(separator: separator, terminator: terminator)
    }
  }
}

extension Sequence where Element: FloatingPoint {

  /// 空白区切りで標準出力へ出力する
  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    var first = true
    forEach { element in
      if first {
        first = false
      } else {
        Swift.print(separator, terminator: "")
      }
      Swift.print(element, terminator: "")
    }
    Swift.print("", terminator: terminator)
  }
}

extension Sequence where Element: Sequence, Element.Element: FloatingPoint {

  @inlinable
  public func print(separator: String = " ", terminator: String = "\n") {
    forEach {
      $0.print(separator: separator, terminator: terminator)
    }
  }
}

extension Sequence where Element == Character {

  @inlinable
  public func print(separator: String = "", terminator: String = "\n") {
    var first = true
    forEach { element in
      if first {
        first = false
      } else {
        Swift.print(separator, terminator: "")
      }
      putchar_unlocked(element)
    }
    Swift.print("", terminator: terminator)
  }
}

extension Sequence where Element: Sequence, Element.Element == Character {

  @inlinable
  public func print(separator: String = "", terminator: String = "\n") {
    forEach {
      $0.print(separator: separator, terminator: terminator)
    }
  }
}

extension Sequence where Element == UInt8 {

  @inlinable
  public func print(separator: String = "", terminator: String = "\n") {
    var first = true
    forEach { element in
      if first {
        first = false
      } else {
        Swift.print(separator, terminator: "")
      }
      putchar_unlocked(element)
    }
    Swift.print("", terminator: terminator)
  }
}

extension Sequence where Element: Sequence, Element.Element == UInt8 {

  @inlinable
  public func print(separator: String = "", terminator: String = "\n") {
    forEach {
      $0.print(separator: separator, terminator: terminator)
    }
  }
}

//@inlinable
//@inline(__always)
//func putchar_unlocked(_ c: Int8) {
//  putchar_unlocked(Int32(c))
//}

@inlinable
@inline(__always)
func putchar_unlocked(_ c: UInt8) {
  putchar_unlocked(Int32(c))
}

@inlinable
@inline(__always)
public func putchar_unlocked(_ c: Character) {
  for b in c.unicodeScalars {
    putchar_unlocked(Int32(bitPattern: b.value))
  }
}
