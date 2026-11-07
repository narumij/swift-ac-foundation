import Foundation
import _FastIO

// 3モードが共有する候補文字のバッファ。候補の切り出しと変換を担う。
@usableFromInline
struct FloatingPointIOReaderBuffer {

  @usableFromInline var buffer: [UInt8] = []

  @usableFromInline nonisolated(unsafe) static var instance = Self()

  @inlinable
  @inline(__always)
  mutating func read<State: FloatingPointInputState>(state initialState: State) throws
    -> ReaderItem<Double>
  {
    buffer.removeAll(keepingCapacity: true)
    var c: UInt8? = try .readHead()
    var state = initialState
    while let _c = c, state.advance(_c) {
      buffer.append(_c)
      c = __getchar_unlocked()
    }
    let count = buffer.count
    do {
      return (try Self.convert(&buffer, isComplete: state.isComplete), c)
    } catch {
      _ = _ungetc(c)
      if let reason = error as? IOReaderError {
        throw FloatingPointInputError(
          reason: reason,
          input: String(decoding: buffer.prefix(count), as: UTF8.self),
          nextByte: c
        )
      }
      throw error
    }
  }

  @inlinable
  @inline(__always)
  static func convert(_ buffer: inout [UInt8], isComplete: Bool) throws -> Double {

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
