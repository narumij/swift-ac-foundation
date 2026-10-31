/// Numeric input validation.
public enum InputCheckMode: Sendable {
  case none
  case strict
}

extension ElementLineReadable {
  
  @inlinable
  public static func read(check: InputCheckMode = .none) throws -> Self {
    try readLine()
  }

  @inlinable
  public static func stdin(check: InputCheckMode = .none) -> Self { try! read(check: check) }

}

extension ExpressibleByElementSequence where Element: InputElementReadable {

  @inlinable
  @inline(__always)
  public static func read(columns: Int, check: InputCheckMode = .none) throws -> Self {
    if case .none = check {
      return Self(try (0..<columns).map { _ in try Element.read() })
    }
    let values = try [Element].readLine()
    guard values.count == columns else {
      throw IOReaderError.elementCountMismatch(expected: columns, actual: values.count)
    }
    return Self(values)
  }

  @inlinable
  @inline(__always)
  public static func read(rows: Int, check: InputCheckMode = .none) throws -> Self {
    switch check {
    case .none: return Self(try (0..<rows).map { _ in try Element.read() })
    case .strict: return Self(try (0..<rows).map { _ in try [Element].read(columns: 1, check: check)[0] })
    }
  }

  @inlinable
  @inline(__always)
  public static func stdin(columns: Int, check: InputCheckMode = .none) -> Self {
    try! read(columns: columns, check: check)
  }

  @inlinable
  @inline(__always)
  public static func stdin(rows: Int, check: InputCheckMode = .none) -> Self {
    try! read(rows: rows, check: check)
  }
}

extension ExpressibleByElementSequence
where Element: ExpressibleByElementSequence, Element.Element: InputElementReadable {

  @inlinable
  @inline(__always)
  public static func read(rows: Int, columns: Int, check: InputCheckMode = .none) throws
    -> Self
  {
    Self(try (0..<rows).map { _ in try Element.read(columns: columns, check: check) })
  }

  @inlinable
  @inline(__always)
  public static func stdin(rows: Int, columns: Int, check: InputCheckMode = .none)
    -> Self
  {
    try! read(rows: rows, columns: columns, check: check)
  }
}
