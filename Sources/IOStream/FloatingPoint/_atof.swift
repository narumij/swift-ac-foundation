import Foundation
@preconcurrency import _FastIO

@usableFromInline
struct _atof: InstanceIOReader {

  nonisolated(unsafe)
    public static var instance = Self()
  
  @usableFromInline
  typealias Element = Double

  public var buffer: [UInt8] = []
  
  @inlinable
  @inline(__always)
  public mutating func read() throws -> Element {
    valuePreservingSeparator(try read())
  }

  @inlinable
  @inline(__always)
  public mutating func read() throws -> Item {
    try read(floatingPointMode: FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!)
  }

  @inlinable
  @inline(__always)
  public mutating func read(floatingPointMode: FloatingPointMode) throws -> Item {
    switch floatingPointMode {
    case .libcxx:
      try read(state: LLVMFloatingPointState())
    case .gccLike:
      try read(state: GCCLikeFloatingPointState())
    case .specific:
      try read(state: StrtodFloatingPointState.start)
    }
  }

  @inlinable
  @inline(__always)
  mutating func read<State: FloatingPointInputState>(state initialState: State) throws -> Item {
    buffer.removeAll(keepingCapacity: true)
    var c: UInt8 = try .readHead()
    var state = initialState
    while c != .NULL && state.advance(c) {
      buffer.append(c)
      c = nullIfEOF(_getchar_unlocked())
    }
    let count = buffer.count
    do {
      return (try convert(&buffer, isComplete: state.isComplete), c)
    } catch {
      if c != .NULL {
        _ = _ungetc(Int32(c))
      }
      if let reason = error as? IOReaderError {
        throw FloatingPointInputError(
          reason: reason,
          input: String(decoding: buffer.prefix(count), as: UTF8.self),
          nextByte: c == .NULL ? nil : c
        )
      }
      throw error
    }
  }
  
  @inlinable
  @inline(__always)
  func convert(_ buffer: inout [UInt8], isComplete: Bool) throws -> Double {

    let count = buffer.count
    buffer.append(.NULL)

    return try buffer.withUnsafeMutableBytes {
      try $0.baseAddress!.withMemoryRebound(to: CChar.self, capacity: $0.count) { start in

        guard count > 0, isComplete else {
          throw IOReaderError.invalidFloatingPoint
        }

        var end: UnsafeMutablePointer<CChar>?

        let savedErrno = errno
        defer { errno = savedErrno }
        errno = 0
        let value = strtod(start, &end)
        guard errno != ERANGE else {
          throw IOReaderError.floatingPointOutOfRange
        }

        guard let end, end - start == count else {
          throw IOReaderError.invalidFloatingPoint
        }

        return value
      }
    }
  }
}
