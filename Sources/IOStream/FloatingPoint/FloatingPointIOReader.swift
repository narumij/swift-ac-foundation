import _FastIO
import Foundation

// 浮動小数の3モードに共通する読取り。モードの違いは候補を切り出す状態機械だけに収める。
@usableFromInline
protocol FloatingPointIOReader: ElementReader where Element == Double {
  associatedtype State: FloatingPointInputState
}

extension FloatingPointIOReader {

  @inlinable
  @inline(__always)
  static func _read() throws -> Item {
    try FloatingPointIOReaderBuffer.instance.read(state: State.start)
  }
}

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
    var c: UInt8 = try .readHead()
    var state = initialState
    while c != .NULL && state.advance(c) {
      buffer.append(c)
      c = nullIfEOF(_getchar_unlocked())
    }
    let count = buffer.count
    do {
      return (try Self.convert(&buffer, isComplete: state.isComplete), c)
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
