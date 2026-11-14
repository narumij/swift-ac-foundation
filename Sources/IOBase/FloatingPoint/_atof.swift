import Foundation
@preconcurrency import _FastIO

@usableFromInline
package struct _atof: StaticIOReader {

  @usableFromInline
  package typealias Element = Double

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try read(mode: FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!)
  }

  @inlinable
  @inline(__always)
  public static func read(mode: FloatingPointMode) throws -> Item {
    switch mode {
    case .libcxx:
      try FloatingPointIOReaderBuffer.instance.read(state: LLVMFloatingPointState())
    case .gccLike:
      try FloatingPointIOReaderBuffer.instance.read(state: StrtodFloatingPointState(allowsHex: false))
    case .specific:
      try FloatingPointIOReaderBuffer.instance.read(state: StrtodFloatingPointState(allowsHex: true))
    }
  }
}
