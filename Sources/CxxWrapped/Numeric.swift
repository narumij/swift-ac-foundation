import _cxx

@inlinable
@inline(__always)
public func gcd(_ a: Int, _ b: Int) -> Int {
  Int(gcd_i64(Int64(a), Int64(b)))
}

@inlinable
@inline(__always)
public func gcd(_ a: UInt, _ b: UInt) -> UInt {
  UInt(gcd_u64(UInt64(a), UInt64(b)))
}

@inlinable
@inline(__always)
public func lcm(_ a: Int, _ b: Int) -> Int {
  Int(lcm_i64(Int64(a), Int64(b)))
}

@inlinable
@inline(__always)
public func lcm(_ a: UInt, _ b: UInt) -> UInt {
  UInt(lcm_u64(UInt64(a), UInt64(b)))
}
