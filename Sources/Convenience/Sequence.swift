extension Sequence where Element: CustomStringConvertible {
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
      Swift.print(element.description, terminator: "")
    }
    Swift.print("", terminator: terminator)
  }
}

extension Sequence where Element == Bool {
  /// 全部真
  @inlinable
  @inline(__always)
  public var all: Bool { allSatisfy{ $0 } }
  /// どれか真
  @inlinable
  @inline(__always)
  public var any: Bool { contains(true) }
}

extension Sequence where Element: AdditiveArithmetic {
  /// 合計
  @inlinable
  @inline(__always)
  public func sum() -> Element { reduce(.zero, +) }
}

extension Sequence where Element: Numeric {
  /// 全部かけ算したやつ
  @inlinable
  @inline(__always)
  public func product() -> Element { reduce(1, *) }
}

extension Sequence where Element: BinaryInteger {
  /// 全部orしたやつ
  @inlinable
  @inline(__always)
  public func or() -> Element { reduce(0, |) }
  /// 全部xorしたやつ
  @inlinable
  @inline(__always)
  public func xor() -> Element { reduce(0, ^) }
}

extension Array where Element: IteratorProtocol {
  @inlinable
  mutating func next() -> [Element.Element]? {
    indices
      .map { self[$0].next() }
      .reduce([]) { partial, item in
        guard let partial, let item else { return nil }
        return partial + [item]
      }
  }
}

extension Sequence where Element: Sequence {
  
  /// 2次元配列を転置します
  @inlinable
  @inline(__always)
  public func transposed() -> [[Element.Element]] {
    var result: [[Element.Element]] = []
    var iterators = map { $0.makeIterator() }
    while let n = iterators.next() {
      result.append(n)
    }
    return result
  }
}

extension Sequence {
  
  /// 条件に合致する数を数えます
  @inlinable
  @inline(__always)
  public func count(where f: (Element) -> Bool) -> Int {
    reduce(0) { $0 + (f($1) ? 1 : 0) }
  }
  
  /// 要素と同じものの数を数えます
  @inlinable
  @inline(__always)
  public func count(_ element: Element) -> Int where Element: Equatable {
    reduce(0) { $0 + ($1 == element ? 1 : 0) }
  }
}
