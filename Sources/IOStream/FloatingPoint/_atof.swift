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
      try _atofReader<LLVMFloatingPointState>.read()
    case .gccLike:
      try _atofReader<GCCLikeFloatingPointState>.read()
    case .specific:
      try _atofReader<StrtodFloatingPointState>.read()
    }
  }
}

extension _atof {

  // 浮動小数の3モードに共通する読取り。モードの違いは候補を切り出す状態機械だけに収める。
  @usableFromInline
  struct _atofReader<State: FloatingPointInputState>: StaticIOSubReader {

    @usableFromInline
    typealias Element = Double

    @inlinable
    @inline(__always)
    static func _read() throws -> Item {
      try FloatingPointIOReaderBuffer.instance.read(state: State.start)
    }
  }
}
