import Foundation

@inlinable
func less<C: Comparable>(lhs: C, rhs: C) -> Bool? {
    guard lhs != rhs else { return nil }
    return lhs < rhs
}

@inlinable
func < <A,B>(lhs: (A,B), rhs: (A,B)) -> Bool
where A: Comparable,
      B: Comparable
{
    func _less(_ key: Int) -> Bool? {
        switch key {
        case 0: return less(lhs: lhs.0, rhs: rhs.0)
        case 1: return less(lhs: lhs.1, rhs: rhs.1)
        default: fatalError()
        }
    }
    return _less(0) ?? _less(1) ?? false
}

@inlinable
func < <A,B,C>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool
where A: Comparable,
      B: Comparable,
      C: Comparable
{
    func _less(_ key: Int) -> Bool? {
        switch key {
        case 0: return less(lhs: lhs.0, rhs: rhs.0)
        case 1: return less(lhs: lhs.1, rhs: rhs.1)
        case 2: return less(lhs: lhs.2, rhs: rhs.2)
        default: fatalError()
        }
    }
    return _less(0) ?? _less(1) ?? _less(2) ?? false
}

@inlinable
func < <A,B,C,D>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool
where A: Comparable,
      B: Comparable,
      C: Comparable,
      D: Comparable
{
    func _less(_ key: Int) -> Bool? {
        switch key {
        case 0: return less(lhs: lhs.0, rhs: rhs.0)
        case 1: return less(lhs: lhs.1, rhs: rhs.1)
        case 2: return less(lhs: lhs.2, rhs: rhs.2)
        case 3: return less(lhs: lhs.3, rhs: rhs.3)
        default: fatalError()
        }
    }
    return _less(0) ?? _less(1) ?? _less(2) ?? _less(3) ?? false
}

@inlinable
func greater<C: Comparable>(lhs: C, rhs: C) -> Bool? {
    guard lhs != rhs else { return nil }
    return lhs > rhs
}

@inlinable
func > <A,B>(lhs: (A,B), rhs: (A,B)) -> Bool
where A: Comparable,
      B: Comparable
{
    func _greater(_ key: Int) -> Bool? {
        switch key {
        case 0: return greater(lhs: lhs.0, rhs: rhs.0)
        case 1: return greater(lhs: lhs.1, rhs: rhs.1)
        default: fatalError()
        }
    }
    return _greater(0) ?? _greater(1) ?? false
}

@inlinable
func > <A,B,C>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool
where A: Comparable,
      B: Comparable,
      C: Comparable
{
    func _greater(_ key: Int) -> Bool? {
        switch key {
        case 0: return greater(lhs: lhs.0, rhs: rhs.0)
        case 1: return greater(lhs: lhs.1, rhs: rhs.1)
        case 2: return greater(lhs: lhs.2, rhs: rhs.2)
        default: fatalError()
        }
    }
    return _greater(0) ?? _greater(1) ?? _greater(2) ?? false
}

@inlinable
func > <A,B,C,D>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool
where A: Comparable,
      B: Comparable,
      C: Comparable,
      D: Comparable
{
    func _greater(_ key: Int) -> Bool? {
        switch key {
        case 0: return greater(lhs: lhs.0, rhs: rhs.0)
        case 1: return greater(lhs: lhs.1, rhs: rhs.1)
        case 2: return greater(lhs: lhs.2, rhs: rhs.2)
        case 3: return greater(lhs: lhs.3, rhs: rhs.3)
        default: fatalError()
        }
    }
    return _greater(0) ?? _greater(1) ?? _greater(2) ?? _greater(3) ?? false
}

