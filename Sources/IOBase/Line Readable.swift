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
    var (value, separator) = try! read()
    while !isNilOrAsciiNewLine(separator), isASCIIWhitespace(separator!) {
      separator = __getchar_unlocked()
    }
    finished = isNilOrAsciiNewLine(separator)
    if !finished {
      _ = __ungetc(separator)
    }
    return value
  }
}

public struct ColumnsIterator<Element>: IteratorProtocol, Sequence {

  package init(columns: Int, read: @escaping () throws -> ReaderItem<Element>) {
    self.columns = columns
    self.read = read
  }

  let read: () throws -> ReaderItem<Element>
  var columns: Int

  public mutating func next() -> Element? {
    guard columns > 0 else { return nil }
    columns -= 1
    let (value, separator) = try! read()
    _ = __ungetc(separator)
    return value
  }
}
