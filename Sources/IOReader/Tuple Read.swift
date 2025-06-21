import Foundation

public typealias TupleReadable = SingleReadable

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func read<each T: TupleReadable>() throws -> (repeat each T) {
  (repeat try (each T).read())
}

/// タプルを一括で読みます
@inlinable
@inline(__always)
public func stdin<each T: TupleReadable>() -> (repeat each T) {
  try! (read() as (repeat each T))
}
