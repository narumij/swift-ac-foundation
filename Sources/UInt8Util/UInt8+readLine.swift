import Foundation
import _cxx

public
  enum UInt8UtilError: Swift.Error
{
  case unexpectedEOF
}

@inlinable
public func _readLine<T>(_ f: (UnsafePointer<UInt8>, Int) throws -> T) throws -> T {
  var utf8Start: UnsafeMutablePointer<UInt8>?
  let utf8Count = _readLine_stdin(&utf8Start)
  defer {
    _free(utf8Start)
  }
  guard utf8Count > 0, let utf8Start else {
    throw UInt8UtilError.unexpectedEOF
  }
  return try f(utf8Start, utf8Count)
}

@inlinable
public func readLine(strippingNewline: Bool = true) -> [UInt8]? {
  try? _readLine { start, count in
    [UInt8].init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      buffer.baseAddress?.initialize(from: start, count: count)
      initializedCount = count
      if strippingNewline, start[count - 1] == 0x0A {
        initializedCount -= 1
      }
    }
  }
}

/// 制限事項: Int8は空白判定方式の都合で直接読めない
@inlinable
public func __readSigned<I>(_ start: UnsafePointer<UInt8>,_ count: Int,_ pos: inout Int) -> I where I: FixedWidthInteger & SignedInteger {
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
    if (1 << c) & (1 << 0x0A | 1 << 0x20) != 0 {
      break
    }
    num = num * 10 + (negative ? -(c &- 0x30) : (c &- 0x30))
  }
  return num
}

/// 制限事項: UInt8は空白判定方式の都合で直接読めない
@inlinable
public func __readUnsigned<U>(_ start: UnsafePointer<UInt8>,_ count: Int,_ pos: inout Int) -> U
where U: FixedWidthInteger & UnsignedInteger {
  while pos < count, start[pos] == 0x20 {
    pos += 1
  }
  var num: U = 0
  var c: U
  while true {
    c = U(start[pos])
    pos += 1
    if (1 << c) & (1 << 0x0A | 1 << 0x20) != 0 {
      break
    }
    num = num * 10 + (c &- 0x30)
  }
  return num
}

/// 制限事項: Int8は空白判定方式の都合で直接読めない
@inlinable
public func __readLine<I>() -> [I]
where I: FixedWidthInteger & SignedInteger {
  try! _readLine { start, count in
    var pos = 0
    var nums: [I] = []
    while pos < count, start[pos] != 0x0A {
      nums.append(__readSigned(start, count, &pos))
    }
    return nums
  }
}

/// 制限事項: UInt8は空白判定方式の都合で直接読めない
@inlinable
public func __readLine<U>() -> [U]
where U: FixedWidthInteger & UnsignedInteger {
  try! _readLine { start, count in
    var pos = 0
    var nums: [U] = []
    while pos < count, start[pos] != 0x0A {
      nums.append(__readUnsigned(start, count, &pos))
    }
    return nums
  }
}
