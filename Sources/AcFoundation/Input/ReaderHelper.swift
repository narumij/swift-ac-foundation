import Foundation

public enum Input { }

public extension Input {
    
    @inlinable @inline(__always)
    static func read<A>() -> A! where A: SingleRead {
        .read()
    }
    
    static func read<A,B>() -> (A,B)!
    where A: TupleRead, B: TupleRead
    {
        (.read(), .read())
    }
    
    static func read<A,B,C>() -> (A,B,C)!
    where A: TupleRead, B: TupleRead, C: TupleRead
    {
        (.read(), .read(), .read())
    }
    
    static func read<A,B,C,D>() -> (A,B,C,D)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead
    {
        (.read(), .read(), .read(), .read())
    }
    
    static func read<A,B,C,D,E>() -> (A,B,C,D,E)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead
    {
        (.read(), .read(), .read(), .read(), .read())
    }
}
