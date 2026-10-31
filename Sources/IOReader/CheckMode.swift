/// Numeric input validation.
public enum InputCheckMode: Sendable {
  case none
  case strict
}

extension Array where Element: LineReadableElement {
  
  @inlinable
  public static func read(check: InputCheckMode = .none) throws -> Self {
    try readLine()
  }

  @inlinable
  public static func stdin(check: InputCheckMode = .none) -> Self { try! read(check: check) }

  /// Checks the count returned by the existing line reader.
  /// Its separator handling is unchanged; this does not introduce a second parser.
  @inlinable
  public static func read(columns: Int, check: InputCheckMode = .none) throws -> Self {

    if case .none = check {
      return try (0..<columns).map { _ in try Element.read() }
    }
    let values = try readLine()
    guard values.count == columns else {
      throw IOReaderError.elementCountMismatch(expected: columns, actual: values.count)
    }
    return values
  }

  @inlinable
  public static func stdin(columns: Int, check: InputCheckMode = .none) -> Self {

    try! read(columns: columns, check: check)
  }

  @inlinable
  public static func read(rows: Int, check: InputCheckMode = .none) throws -> Self {

    switch check {
    case .none: return try (0..<rows).map { _ in try Element.read() }
    case .strict: return try (0..<rows).map { _ in try read(columns: 1, check: check)[0] }
    }
  }

  @inlinable
  public static func stdin(rows: Int, check: InputCheckMode = .none) -> Self {

    try! read(rows: rows, check: check)
  }
}

extension Set where Element: LineReadableElement {

  @inlinable
  public static func read(check: InputCheckMode = .none) throws -> Self { try readLine() }

  @inlinable
  public static func stdin(check: InputCheckMode = .none) -> Self { try! read(check: check) }
}

extension Array where Element: LineReadable {

  @inlinable
  public static func read(rows: Int, check: InputCheckMode = .none) throws -> Self {

    try readLines(count: rows)
  }

  @inlinable
  public static func stdin(rows: Int, check: InputCheckMode = .none) -> Self {

    try! read(rows: rows, check: check)
  }
}

extension Array {

  @inlinable
  public static func read<Value>(rows: Int, columns: Int, check: InputCheckMode = .none) throws
    -> Self
  where Element == [Value], Value: LineReadableElement {

    try (0..<rows).map { _ in try Element.read(columns: columns, check: check) }
  }

  @inlinable
  public static func stdin<Value>(rows: Int, columns: Int, check: InputCheckMode = .none)
    -> Self
  where Element == [Value], Value: LineReadableElement {

    try! read(rows: rows, columns: columns, check: check)
  }
}
