import Foundation
@preconcurrency import _FastIO

@usableFromInline
struct _atof: StaticIOReader {

  @usableFromInline
  typealias Element = Double

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try read(floatingPointMode: FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!)
  }

  @inlinable
  @inline(__always)
  public static func read(floatingPointMode: FloatingPointMode) throws -> Item {
    switch floatingPointMode {
    case .libcxx:
      try _atofLibcxx.read()
    case .gccLike:
      try _atofGCCLike.read()
    case .specific:
      try _atofSpecific.read()
    }
  }
}

extension _atof {

  @usableFromInline
  struct _atofLibcxx: FloatingPointIOReader, StaticIOSubReader {
    @usableFromInline typealias State = LLVMFloatingPointState
  }

  @usableFromInline
  struct _atofGCCLike: FloatingPointIOReader, StaticIOSubReader {
    @usableFromInline typealias State = GCCLikeFloatingPointState
  }

  @usableFromInline
  struct _atofSpecific: FloatingPointIOReader, StaticIOSubReader {
    @usableFromInline typealias State = StrtodFloatingPointState
  }
}
