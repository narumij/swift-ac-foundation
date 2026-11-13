import Foundation
import _FastIO

protocol LineReader: ElementReader {

  static func read() throws -> Item
}

extension LineReader {

  @inlinable
  @inline(__always)
  static func readLine() -> [Element] {
    Array(makeLineIterator(read))
  }
  
  @inlinable
  @inline(__always)
  static func readLine() -> Set<Element>
  where Element: Hashable {
    Set(makeLineIterator(read))
  }
}

public struct LineIterator<Element>: IteratorProtocol, Sequence {
  
  let read: () throws -> ReaderItem<Element>
  var remaining: Int? = nil
  var finished = false

  public mutating func next() -> Element? {
    guard !finished else { return nil }
    let (value, separator) = try! read()
    let lineEnd = isNilOrAsciiNewLine(separator)
    if let remaining {
      precondition(lineEnd == (remaining == 1))
      self.remaining = remaining - 1
      finished = remaining == 1
    } else {
      finished = lineEnd
    }
    if !lineEnd {
      _ = __ungetc(separator)
    }
    return value
  }
}

package func makeLineIterator<Element>(
  _ read: @escaping () throws -> ReaderItem<Element>
) -> LineIterator<Element> {
  LineIterator(read: read)
}

package func makeLineIterator<Element>(
  columns: Int,
  _ read: @escaping () throws -> ReaderItem<Element>
) -> LineIterator<Element> {
  LineIterator(read: read, remaining: columns, finished: columns == 0)
}

public struct CharacterIterator<Element>: IteratorProtocol, Sequence {

  let convert: (UInt8) -> Element
  var remaining: Int? = nil
  var finished = false

  public mutating func next() -> Element? {
    guard !finished else { return nil }
    let c: UInt8? = __getchar_unlocked()
    guard let c, !isASCIINewline(c) else {
      precondition(remaining ?? 0 == 0)
      if c == .CR, let lf: UInt8 = __getchar_unlocked(), lf != .LF {
        _ = __ungetc(lf)
      }
      finished = true
      return nil
    }
    precondition(remaining != 0)
    remaining = remaining.map { $0 - 1 }
    return convert(c)
  }
}

package func makeCharacterIterator<Element>(
  _ convert: @escaping (UInt8) -> Element
) -> CharacterIterator<Element> {
  CharacterIterator(convert: convert)
}

package func makeCharacterIterator<Element>(
  columns: Int,
  _ convert: @escaping (UInt8) -> Element
) -> CharacterIterator<Element> {
  if columns > 0 {
    _ = __ungetc(try! UInt8.readHead())
  }
  return CharacterIterator(convert: convert, remaining: columns)
}
