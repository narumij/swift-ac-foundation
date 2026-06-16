import _FastIO

public
  enum IOUtilError: Swift.Error
{
  case unexpectedEmpty
}

/// 入力ライブラリを自作するときに、行単位の読み取りで詰まった場合の補助関数です。
/// `body` に渡されるバイト列は、この関数の呼び出し中だけ有効です。
@inlinable
@inline(__always)
public func withUnsafeReadLineBytes<T>(_ body: (UnsafeBufferPointer<UInt8>) throws -> T) throws -> T {
  var utf8Start: UnsafeMutablePointer<UInt8>?
  let utf8Count = _readLine_stdin(&utf8Start)
  defer {
    _free(utf8Start)
  }
  guard utf8Count > 0, let utf8Start else {
    throw IOUtilError.unexpectedEmpty
  }
  return try body(UnsafeBufferPointer(start: utf8Start, count: utf8Count))
}

// MARK: -

@inlinable
public func readIntLine<I>() -> [I]
where I: FixedWidthInteger & SignedInteger {
  try! withUnsafeReadLineBytes { buffer in
    let start = buffer.baseAddress!
    let count = buffer.count
    var pos = 0
    var nums: [I] = []
    while pos < count {
      while pos < count, start[pos] == 0x20 {
        pos += 1
      }
      if pos >= count || start[pos] == 0x0A || start[pos] == 0x0D {
        break
      }
      nums.append(_parseSigned(start, count, &pos))
    }
    return nums
  }
}

@inlinable
public func readUIntLine<U>() -> [U]
where U: FixedWidthInteger & UnsignedInteger {
  try! withUnsafeReadLineBytes { buffer in
    let start = buffer.baseAddress!
    let count = buffer.count
    var pos = 0
    var nums: [U] = []
    while pos < count {
      while pos < count, start[pos] == 0x20 {
        pos += 1
      }
      if pos >= count || start[pos] == 0x0A || start[pos] == 0x0D {
        break
      }
      nums.append(_parseUnsigned(start, count, &pos))
    }
    return nums
  }
}

@inlinable
func _parseSigned<I>(_ start: UnsafePointer<UInt8>,_ count: Int,_ pos: inout Int) -> I where I: FixedWidthInteger & SignedInteger {
  while pos < count, start[pos] == 0x20 {
    pos += 1
  }
  var num: I = 0
  var negative: Bool = false
  var c: I = I(start[pos])
  pos += 1
  if c == 0x2D {
    negative = true
  } else {
    num = c - 0x30
  }
  while true {
    c = I(start[pos])
    pos += 1
    if c == 0x0A || c == 0x0D || c == 0x20 {
      break
    }
    num = num * 10 + (negative ? -(c &- 0x30) : (c &- 0x30))
  }
  return num
}

@inlinable
func _parseUnsigned<U>(_ start: UnsafePointer<UInt8>,_ count: Int,_ pos: inout Int) -> U
where U: FixedWidthInteger & UnsignedInteger {
  while pos < count, start[pos] == 0x20 {
    pos += 1
  }
  var num: U = 0
  var c: U
  while true {
    c = U(start[pos])
    pos += 1
    if c == 0x0A || c == 0x0D || c == 0x20 {
      break
    }
    num = num * 10 + (c &- 0x30)
  }
  return num
}

import _FastIO

@inlinable
public func readIntLine_V1() -> [Int] {
  try! withUnsafeReadLineBytes { buffer in
    let start = buffer.baseAddress!
    let count = buffer.count

    var pos = 0
    var result: [Int] = []
    result.reserveCapacity(count >> 1)

    while pos < count {
      // ASCII whitespace skip
      while pos < count, start[pos] <= 0x20 {
        pos += 1
      }

      if pos >= count {
        break
      }

      var negative = false

      if start[pos] == 0x2D { // "-"
        negative = true
        pos += 1
      }

      let digitStart = pos

      while pos < count, start[pos] > 0x20 {
        pos += 1
      }

      let digitCount = pos - digitStart
      let magnitude = _parseUInt64Digits(start + digitStart, digitCount)

      let value: Int
      if negative {
        value = 0 &- Int(truncatingIfNeeded: magnitude)
      } else {
        value = Int(truncatingIfNeeded: magnitude)
      }

      result.append(value)
    }

    return result
  }
}

@inlinable
public func readIntLine_new() -> [Int] {
  try! withUnsafeReadLineBytes { buffer in
    let start = buffer.baseAddress!
    let end = start + buffer.count

    var p = start

    var result: [Int] = []
    result.reserveCapacity(buffer.count >> 1)

    while p < end {

      while p < end, p.pointee <= 0x20 {
        p += 1
      }

      if p >= end {
        break
      }

      let negative = p.pointee == 0x2D
      if negative {
        p += 1
      }

      var value: UInt64 = 0

      while p < end {
        let c = p.pointee

        if c <= 0x20 {
          break
        }

        value = value &* 10 &+ UInt64(c &- 48)

        p += 1
      }

      result.append(
        negative
          ? 0 &- Int(truncatingIfNeeded: value)
          : Int(truncatingIfNeeded: value)
      )
    }

    return result
  }
}

@inlinable
@inline(__always)
func _digit(_ p: UnsafePointer<UInt8>, _ i: Int) -> UInt64 {
  UInt64(p[i] &- 0x30)
}

@inlinable
@inline(__always)
func _parseUInt64Digits(_ p: UnsafePointer<UInt8>, _ count: Int) -> UInt64 {
  switch count {
  case 0:
    return 0

  case 1:
    return _digit(p, 0)

  case 2:
    return _digit(p, 0) * 10
      + _digit(p, 1)

  case 3:
    return _digit(p, 0) * 100
      + _digit(p, 1) * 10
      + _digit(p, 2)

  case 4:
    return _digit(p, 0) * 1_000
      + _digit(p, 1) * 100
      + _digit(p, 2) * 10
      + _digit(p, 3)

  case 5:
    return _digit(p, 0) * 10_000
      + _digit(p, 1) * 1_000
      + _digit(p, 2) * 100
      + _digit(p, 3) * 10
      + _digit(p, 4)

  case 6:
    return _digit(p, 0) * 100_000
      + _digit(p, 1) * 10_000
      + _digit(p, 2) * 1_000
      + _digit(p, 3) * 100
      + _digit(p, 4) * 10
      + _digit(p, 5)

  case 7:
    return _digit(p, 0) * 1_000_000
      + _digit(p, 1) * 100_000
      + _digit(p, 2) * 10_000
      + _digit(p, 3) * 1_000
      + _digit(p, 4) * 100
      + _digit(p, 5) * 10
      + _digit(p, 6)

  case 8:
    return _digit(p, 0) * 10_000_000
      + _digit(p, 1) * 1_000_000
      + _digit(p, 2) * 100_000
      + _digit(p, 3) * 10_000
      + _digit(p, 4) * 1_000
      + _digit(p, 5) * 100
      + _digit(p, 6) * 10
      + _digit(p, 7)

  case 9:
    return _digit(p, 0) * 100_000_000
      + _digit(p, 1) * 10_000_000
      + _digit(p, 2) * 1_000_000
      + _digit(p, 3) * 100_000
      + _digit(p, 4) * 10_000
      + _digit(p, 5) * 1_000
      + _digit(p, 6) * 100
      + _digit(p, 7) * 10
      + _digit(p, 8)

  case 10:
    return _digit(p, 0) * 1_000_000_000
      + _digit(p, 1) * 100_000_000
      + _digit(p, 2) * 10_000_000
      + _digit(p, 3) * 1_000_000
      + _digit(p, 4) * 100_000
      + _digit(p, 5) * 10_000
      + _digit(p, 6) * 1_000
      + _digit(p, 7) * 100
      + _digit(p, 8) * 10
      + _digit(p, 9)

  default:
    var value: UInt64 = 0
    for i in 0..<count {
      value = value &* 10 &+ _digit(p, i)
    }
    return value
  }
}
