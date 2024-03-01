import Foundation

// MARK: - ReadHelper

typealias Int2 = (Int,Int)
typealias Int3 = (Int,Int,Int)
typealias Int4 = (Int,Int,Int,Int)
typealias Int5 = (Int,Int,Int,Int,Int)
typealias Int6 = (Int,Int,Int,Int,Int,Int)

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
    
    static func read<A,B,C,D,E,F>() -> (A,B,C,D,E,F)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead, F: TupleRead
    {
        (.read(), .read(), .read(), .read(), .read(), .read())
    }
}

extension Array where Element: RawRepresentable, Element.RawValue == UInt8 {
    static func read(columns: Int) -> [Element] {
        [UInt8].read(columns: columns)
            .compactMap(Element.init)
    }
}

extension Array where Element: Sequence, Element.Element: RawRepresentable, Element.Element.RawValue == UInt8 {
    static func read(rows: Int, columns: Int) -> [[Element.Element]] {
        [[UInt8]].read(rows: rows, columns: columns)
            .map {
                $0.compactMap(Element.Element.init)
            }
    }
}
