import _MT19937

@usableFromInline
final class _MT19937_64 {
  @usableFromInline
  var rng: UnsafeMutablePointer<_MT19937.mt19937_64>
  @inlinable
  public init(seed: UInt32) {
    rng = mt19937_64_create(seed)
  }
  @inlinable
  init(copying source: _MT19937_64) {
    rng = mt19937_64_clone(source.rng)
  }
  deinit {
    mt19937_64_destroy(rng)
  }
  @inlinable
  public func next() -> UInt64 {
    mt19937_64_next_u64(rng)
  }
  @inlinable
  public func discard(_ z: UInt64) {
    mt19937_64_discard(rng, z)
  }
}

public struct mt19937_64: RandomNumberGenerator {
  @usableFromInline
  var rng: _MT19937_64
  @inlinable
  public init(seed: UInt32) {
    rng = .init(seed: seed)
  }
  @inlinable
  mutating func ensureUnique() {
    if !isKnownUniquelyReferenced(&rng) {
      rng = _MT19937_64(copying: rng)
    }
  }
  @inlinable
  public mutating func next() -> UInt64 {
    ensureUnique()
    return rng.next()
  }
  @inlinable
  public mutating func discard(_ z: UInt64) {
    ensureUnique()
    rng.discard(z)
  }
}

// Shared engine state is read-only: next() and discard() detach before mutation.
// As with other value types, concurrent access to the same variable requires synchronization.
extension mt19937_64: @unchecked Sendable { }
