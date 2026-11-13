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

public protocol LineIteratorProtocol: IteratorProtocol, Sequence {}

public struct LineIterator<Element>: LineIteratorProtocol {
  
  let read: () throws -> ReaderItem<Element>
  var finished = false

  public mutating func next() -> Element? {
    guard !finished else { return nil }
    let (value, separator) = try! read()
    finished = isNilOrAsciiNewLine(separator)
    if !finished {
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

public struct FloatingPointLineIterator<Element: BinaryFloatingPoint>: LineIteratorProtocol {
  
  let read: () throws -> ReaderItem<Double>
  var finished = false

  public mutating func next() -> Element? {
    guard !finished else { return nil }
    let (value, separator) = try! read()
    finished = isNilOrAsciiNewLine(separator)
    if !finished {
      _ = __ungetc(separator)
    }
    return .init(value)
  }
}

package func makeFloatingPointLineIterator<Element: BinaryFloatingPoint>(
  _ read: @escaping () throws -> ReaderItem<Double>
) -> FloatingPointLineIterator<Element> {
  FloatingPointLineIterator(read: read)
}
