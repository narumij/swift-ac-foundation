/// Reading one textual value. Existing property-style `stdin` still reads one word.
public enum TextInputMode: Sendable {
  case word
  /// Read the remainder of the physical line, preserving spaces, without its newline.
  case line
}

/// Split a physical line into ASCII whitespace-separated words.
public enum WordsInputMode: Sendable { case words }

// Text modes choose how to read one value; rows alone denotes physical lines.
// Throwing line reads require input; EOF is not an empty line.
private func inputLineBytes() throws -> [UInt8] {
  guard let bytes = [UInt8].readLine() else { throw IOReaderError.unexpectedEOF }
  return bytes
}

private func inputWords() throws -> [[UInt8]] {
  try inputLineBytes().split { $0 == 32 || (9...13).contains($0) }.map(Array.init)
}

extension String {
  public static func read(read mode: TextInputMode) throws -> Self {
    switch mode {
    case .word: return try read()
    case .line:
      let bytes = try inputLineBytes()
      return String(decoding: bytes, as: UTF8.self)
    }
  }

  public static func stdin(read mode: TextInputMode) -> Self { try! read(read: mode) }
}

extension Array where Element == String {
  public static func read(read mode: WordsInputMode) throws -> Self {
    try inputWords().map { bytes in String(decoding: bytes, as: UTF8.self) }
  }

  public static func stdin(read mode: WordsInputMode) -> Self { try! read(read: mode) }
}

extension Array where Element == [String] {
  public static func read(read mode: WordsInputMode, rows: Int) throws -> Self {
    try (0..<rows).map { _ in try Element.read(read: mode) }
  }

  public static func stdin(read mode: WordsInputMode, rows: Int) -> Self {
    try! read(read: mode, rows: rows)
  }
}

extension Array where Element == Character {
  public static func read(read mode: TextInputMode) throws -> Self {
    switch mode {
    case .word: return try read()
    case .line:
      let bytes = try inputLineBytes()
      return bytes.map { Character(UnicodeScalar($0)) }
    }
  }

  public static func stdin(read mode: TextInputMode) -> Self { try! read(read: mode) }
}

extension Array where Element == [Character] {
  public static func read(rows: Int) throws -> Self {
    try (0..<rows).map { _ in try Element.read(read: TextInputMode.line) }
  }

  public static func read(read mode: WordsInputMode) throws -> Self {
    try inputWords().map { bytes in bytes.map { Character(UnicodeScalar($0)) } }
  }

  public static func stdin(read mode: WordsInputMode) -> Self { try! read(read: mode) }
}

extension Array where Element == [[Character]] {
  public static func read(read mode: WordsInputMode, rows: Int) throws -> Self {
    try (0..<rows).map { _ in try Element.read(read: mode) }
  }

  public static func stdin(read mode: WordsInputMode, rows: Int) -> Self {
    try! read(read: mode, rows: rows)
  }
}

extension Array where Element == UInt8 {
  public static func read(read mode: TextInputMode) throws -> Self {
    switch mode {
    case .word: return try read()
    case .line:
      let bytes = try inputLineBytes()
      return bytes
    }
  }

  public static func stdin(read mode: TextInputMode) -> Self { try! read(read: mode) }
}

extension Array where Element == [UInt8] {
  public static func read(rows: Int) throws -> Self {
    try (0..<rows).map { _ in try Element.read(read: TextInputMode.line) }
  }

  public static func read(read mode: WordsInputMode) throws -> Self {
    try inputWords().map { bytes in bytes }
  }

  public static func stdin(read mode: WordsInputMode) -> Self { try! read(read: mode) }
}

extension Array where Element == [[UInt8]] {
  public static func read(read mode: WordsInputMode, rows: Int) throws -> Self {
    try (0..<rows).map { _ in try Element.read(read: mode) }
  }

  public static func stdin(read mode: WordsInputMode, rows: Int) -> Self {
    try! read(read: mode, rows: rows)
  }
}
