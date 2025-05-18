import Foundation

public typealias TupleRead = SingleReadable

/// 2要素のタプルを一括で読みます
@inlinable
public func read<A, B>() throws -> (A, B)
where A: TupleRead, B: TupleRead {
  (try .read(), try .read())
}

/// 3要素のタプルを一括で読みます
@inlinable
public func read<A, B, C>() throws -> (A, B, C)
where A: TupleRead, B: TupleRead, C: TupleRead {
  (try .read(), try .read(), try .read())
}

/// 4要素のタプルを一括で読みます
@inlinable
public func read<A, B, C, D>() throws -> (A, B, C, D)
where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead {
  (try .read(), try .read(), try .read(), try .read())
}

/// 5要素のタプルを一括で読みます
@inlinable
public func read<A, B, C, D, E>() throws -> (A, B, C, D, E)
where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead {
  (try .read(), try .read(), try .read(), try .read(), try .read())
}

/// 6要素のタプルを一括で読みます
@inlinable
public func read<A, B, C, D, E, F>() throws -> (A, B, C, D, E, F)
where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead, F: TupleRead {
  (try .read(), try .read(), try .read(), try .read(), try .read(), try .read())
}

/// タプルを一括で読みます
///
/// 名前に反して1行を読むわけではないです。
/// 慣れやすさでこの名前にしています。
@inlinable
public func readLine<A, B>() -> (A, B)?
where A: TupleRead, B: TupleRead {
  try? read()
}

/// タプルを一括で読みます
///
/// 名前に反して1行を読むわけではないです。
/// 慣れやすさでこの名前にしています。
@inlinable
public func readLine<A, B, C>() -> (A, B, C)?
where A: TupleRead, B: TupleRead, C: TupleRead {
  try? read()
}

/// タプルを一括で読みます
///
/// 名前に反して1行を読むわけではないです。
/// 慣れやすさでこの名前にしています。
@inlinable
public func readLine<A, B, C, D>() -> (A, B, C, D)?
where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead {
  try? read()
}

/// タプルを一括で読みます
///
/// 名前に反して1行を読むわけではないです。
/// 慣れやすさでこの名前にしています。
@inlinable
public func readLine<A, B, C, D, E>() -> (A, B, C, D, E)?
where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead {
  try? read()
}

/// タプルを一括で読みます
///
/// 名前に反して1行を読むわけではないです。
/// 慣れやすさでこの名前にしています。
@inlinable
public func readLine<A, B, C, D, E, F>() -> (A, B, C, D, E, F)?
where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead, F: TupleRead {
  try? read()
}
