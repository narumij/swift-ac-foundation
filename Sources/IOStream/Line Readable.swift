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

package struct LineIterator<Element>: IteratorProtocol, Sequence {
  
  let read: () throws -> ReaderItem<Element>
  var finished = false

  package mutating func next() -> Element? {
    guard !finished else { return nil }
    let (value, separator) = try! read()
    _ = __ungetc(separator)
    finished = isNilOrAsciiNewLine(separator)
    return value
  }
}

package func makeLineIterator<Element>(
  _ read: @escaping () throws -> ReaderItem<Element>
) -> LineIterator<Element> {
  LineIterator(read: read)
}
