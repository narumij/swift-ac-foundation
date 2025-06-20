import Foundation

public typealias TupleRead = SingleReadable

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func read<each T: TupleRead>() throws -> (repeat each T) {
  (repeat try (each T).read())
}

/// タプルを一括で読みます
///
/// 名前に反して1行を読むわけではないです。
/// 慣れやすさでこの名前にしています。
@inlinable
@inline(__always)
public func _readLine<each T: TupleRead>() -> (repeat each T)? {
  try? (repeat (each T).read())
}
