import Foundation
import _FastIO

public struct LineIterator<Element>: IteratorProtocol, Sequence {
  
  package init(read: @escaping () throws -> ReaderItem<Element>, finished: Bool = false) {
    self.read = read
    self.finished = finished
  }

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
