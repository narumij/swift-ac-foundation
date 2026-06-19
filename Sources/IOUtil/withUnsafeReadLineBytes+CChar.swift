// library-checker用

@preconcurrency import Foundation

@inlinable
func __readLine_stdin(
  _ p: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>
) -> Int {
  var capacity = 0
  var result = 0

  repeat {
    result = getline(p, &capacity, stdin)
  } while result < 0 && errno == EINTR

  return result
}

@inlinable
@inline(__always)
public func __withUnsafeReadLineBytes<T>(
  _ body: (UnsafeBufferPointer<UInt8>) throws -> T
) rethrows -> T {
  var utf8Start: UnsafeMutablePointer<CChar>?
  let utf8Count = __readLine_stdin(&utf8Start)

  defer {
    free(utf8Start)
  }

  return try utf8Start!.withMemoryRebound(to: UInt8.self, capacity: utf8Count) {
    try body(UnsafeBufferPointer(start: $0, count: utf8Count))
  }
}

@inlinable
@inline(__always)
public func __withUnsafeReadBytes<T>(
  capacity: Int = 1 << 20,
  _ body: (UnsafeBufferPointer<UInt8>) throws -> T
) rethrows -> T {
  var capacity = capacity
  var count = 0

  var buffer = UnsafeMutablePointer<CChar>.allocate(capacity: capacity + 1)

  defer {
    buffer.deallocate()
  }

  while true {
    if count == capacity {
      let newCapacity = capacity + (capacity >> 1)
      let newBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: newCapacity + 1)

      newBuffer.update(from: buffer, count: count)
      buffer.deallocate()

      buffer = newBuffer
      capacity = newCapacity
    }

    let readCount = fread(buffer + count, 1, capacity - count, stdin)

    if readCount == 0 {
      break
    }

    count += readCount
  }

  buffer[count] = 0

  return try buffer.withMemoryRebound(to: UInt8.self, capacity: count + 1) {
    try body(
      UnsafeBufferPointer(start: $0, count: count + 1)
    )
  }
}

// MARK: -

@inlinable
@inline(__always)
func ___readInt(
  _ start: UnsafeBufferPointer<UInt8>,
  _ pos: inout Int
) -> Int {
  while pos < start.count, start[pos] == 0x20 {
    pos &+= 1
  }

  var value: Int = 0

  while true {
    let c = start[pos]
    pos &+= 1

    if c == 0x20 || c == 0x0A {
      break
    }

    value = value &* 10 &+ Int(c) &- 48
  }

  return value
}

@inlinable
func ___readPair() -> (Int, Int) {

  __withUnsafeReadLineBytes { buffer in

    var pos = 0

    return (
      ___readInt(buffer, &pos),
      ___readInt(buffer, &pos)
    )
  }
}
