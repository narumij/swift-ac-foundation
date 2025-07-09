@inlinable
@inline(__always)
public func < <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == Character,
  RHS: Sequence, RHS.Element == Character
{
  lhs.lexicographicallyPrecedes(rhs)
}

@inlinable
@inline(__always)
public func == <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Collection, LHS.Element == Character,
  RHS: Collection, RHS.Element == Character
{
  lhs.count == rhs.count && lhs.elementsEqual(rhs)
}

@inlinable
@inline(__always)
public func != <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Collection, LHS.Element == Character,
  RHS: Collection, RHS.Element == Character
{
  !(lhs == rhs)
}

@inlinable
@inline(__always)
public func > <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == Character,
  RHS: Sequence, RHS.Element == Character
{
  rhs < lhs
}

@inlinable
@inline(__always)
public func <= <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == Character,
  RHS: Sequence, RHS.Element == Character
{
  return !(lhs > rhs)
}

@inlinable
@inline(__always)
public func >= <LHS, RHS>(lhs: LHS, rhs: RHS) -> Bool
where
  LHS: Sequence, LHS.Element == Character,
  RHS: Sequence, RHS.Element == Character
{
  return !(lhs < rhs)
}
