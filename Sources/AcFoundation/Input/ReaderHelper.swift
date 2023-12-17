import Foundation

public protocol SingleRead {
    @inlinable @inline(__always)
    static func read() -> Self!
}

public protocol TupleRead: SingleRead { }
public protocol ArrayRead: SingleRead { }
public protocol FullRead: ArrayRead & TupleRead { }

public enum Input {
    
    @inlinable @inline(__always)
    public static func read<A>() -> A! where A: SingleRead {
        A.read()
    }
    
    public static func read<A,B>() -> (A,B)!
    where A: TupleRead, B: TupleRead
    {
        (A.read()!, B.read()!)
    }
    
    public static func read<A,B,C>() -> (A,B,C)!
    where A: TupleRead, B: TupleRead, C: TupleRead
    {
        (A.read()!, B.read()!, C.read()!)
    }
    
    public static func read<A,B,C,D>() -> (A,B,C,D)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead
    {
        (A.read()!, B.read()!, C.read()!, D.read()!)
    }
    
    public static func read<A,B,C,D,E>() -> (A,B,C,D,E)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead
    {
        (A.read()!, B.read()!, C.read()!, D.read()!, E.read()!)
    }
    
    @inlinable @inline(__always)
    static func read() -> [CChar]! {
        [CChar].read()
    }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [CChar]! {
        guard let values = [CChar].read() else { return nil }
        assert(values.count == columns)
        return values
    }
    
    static func read(rows: Int) -> [[CChar]] {
        var X: [[CChar]] = []
        X.reserveCapacity(rows)
        for _ in 0..<rows {
            X.append(read())
        }
        return X
    }
    
    static func read(rows: Int, columns: Int) -> [[CChar]]
    {
        var X: [[CChar]] = []
        X.reserveCapacity(rows)
        (0..<rows).forEach { _ in
            X.append(Input.read(columns: columns))
        }
        assert(X.count == rows)
        return X
    }
    
    static func read<A>(columns: Int) -> [A]
    where A: ArrayRead
    {
        var X: [A] = []
        X.reserveCapacity(columns)
        (0..<columns).forEach { _ in
            X.append(Input.read())
        }
        return X
    }
    
    static func read<A>(rows: Int) -> [A]
    where A: ArrayRead
    {
        var X: [A] = []
        X.reserveCapacity(rows)
        (0..<rows).forEach { _ in
            X.append(Input.read())
        }
        return X
    }
    
    static func read<A>(rows: Int, columns: Int) -> [[A]]
    where A: ArrayRead
    {
        var X: [[A]] = []
        X.reserveCapacity(rows)
        (0..<rows).forEach { _ in
            X.append(Input.read(columns: columns))
        }
        assert(X.count == rows)
        return X
    }
}

extension Int: FullRead { }
extension Double: FullRead { }
extension String: FullRead { }
extension CInt: FullRead { }
extension CUnsignedInt: FullRead { }
extension CLongLong: FullRead { }
extension CUnsignedLongLong: FullRead { }

extension RandomAccessCollection where Element: SingleRead {
    static func read(columns: Int) -> [Element] {
        (0..<columns).map{ _ in Element.read() }
    }
    static func read(rows: Int) -> [Element] {
        (0..<rows).map{ _ in Element.read() }
    }
}

extension RandomAccessCollection where Element: RandomAccessCollection, Element.Element: SingleRead {
    static func read(rows: Int, columns: Int) -> [[Element.Element]] {
        (0..<rows).map{ _ in Element.read(columns: columns) }
    }
}
