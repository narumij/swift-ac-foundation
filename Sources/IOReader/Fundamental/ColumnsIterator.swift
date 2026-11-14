import IOBase

public struct ColumnsIterator<Element>: IteratorProtocol, Sequence {

  @inlinable
  package init(columns: Int, read: @escaping () throws -> ReaderItem<Element>) {
    self.columns = columns
    self.read = read
  }

  @usableFromInline
  let read: () throws -> ReaderItem<Element>
  @usableFromInline
  var columns: Int

  @inlinable
  public mutating func next() -> Element? {
    guard columns > 0 else { return nil }
    columns -= 1
    var (value, separator) = try! read()
    while !isNilOrAsciiNewLine(separator), isASCIIWhitespace(separator!) {
      separator = __getchar_unlocked()
    }
    if columns > 0 {
      precondition(!isNilOrAsciiNewLine(separator), "the line ended before all columns were read: read \(value), next \(describeByte(separator))")
      _ = __ungetc(separator)
    } else {
      precondition(isNilOrAsciiNewLine(separator), "the line has more values than the columns: read \(value), next \(describeByte(separator))")
    }
    return value
  }
}
