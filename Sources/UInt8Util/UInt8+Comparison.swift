
@inlinable
@inline(__always)
public func < <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == UInt8,
  RHS: Sequence, RHS.Element == UInt8
{
  lhs.lexicographicallyPrecedes(rhs)
}

@inlinable
@inline(__always)
public func == <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Collection, LHS.Element == UInt8,
  RHS: Collection, RHS.Element == UInt8
{
  lhs.count == rhs.count && lhs.elementsEqual(rhs)
}

@inlinable
@inline(__always)
public func != <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Collection, LHS.Element == UInt8,
  RHS: Collection, RHS.Element == UInt8
{
  !(lhs == rhs)
}

@inlinable
@inline(__always)
public func > <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == UInt8,
  RHS: Sequence, RHS.Element == UInt8
{
  rhs < lhs
}

@inlinable
@inline(__always)
public func <= <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == UInt8,
  RHS: Sequence, RHS.Element == UInt8
{
  return !(lhs > rhs)
}

@inlinable
@inline(__always)
public func >= <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == UInt8,
  RHS: Sequence, RHS.Element == UInt8
{
  return !(lhs < rhs)
}
