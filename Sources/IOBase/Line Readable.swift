public struct LineIterator<Element>: IteratorProtocol, Sequence {
  
  @inlinable
  package init(read: @escaping () throws -> ReaderItem<Element>, finished: Bool = false) {
    self.read = read
    self.finished = finished
  }

  @usableFromInline
  let read: () throws -> ReaderItem<Element>
  @usableFromInline
  var finished = false

  @inlinable
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
