/// A sequence constructed from an array of input values.
/// Shape checks apply to the input array before conversion (for example, Set deduplication).
public protocol ExpressibleByElementSequence: Sequence {
  init(_ elements: [Element])
}

extension Array: ExpressibleByElementSequence {}
extension Set: ExpressibleByElementSequence {}
