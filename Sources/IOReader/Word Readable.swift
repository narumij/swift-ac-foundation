@inlinable
func __readLine_word<Element>(
  _ readWithSeparator: () throws -> (value: Element, separator: UInt8)
) throws -> [Element] {
  var result = [Element]()
  while true {
    let (element, separator) = try readWithSeparator()
    result.append(element)
    if isASCIINewlineOrNull(separator) {
      break
    }
  }
  return result
}

extension Array where Element == String {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine_words() throws -> [String] {
    try __readLine_word(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin_words() -> [String] {
    try! readLine_words()
  }
}

extension Array where Element == [Character] {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine_words() throws -> [[Character]] {
    try __readLine_word(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin_words() -> [[Character]] {
    try! readLine_words()
  }
}

extension Array where Element == [UInt8] {

  // 空白区切りの単語を行末まで読む
  @inlinable
  @inline(__always)
  public static func readLine_words() throws -> [[UInt8]] {
    try __readLine_word(Element._readWithSeparator)
  }

  @inlinable
  @inline(__always)
  public static func stdin_words() -> [[UInt8]] {
    try! readLine_words()
  }
}
