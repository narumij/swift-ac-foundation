import Foundation

// MARK: - ReadHelper

public typealias Int2 = (Int, Int)
public typealias Int3 = (Int, Int, Int)
public typealias Int4 = (Int, Int, Int, Int)
public typealias Int5 = (Int, Int, Int, Int, Int)
public typealias Int6 = (Int, Int, Int, Int, Int, Int)

public enum Input {}

extension Input {

  @inlinable @inline(__always)
  public static func read<A>() -> A! where A: SingleRead {
    try! ._read()
  }

  @inlinable
  public static func read<A, B>() -> (A, B)!
  where A: TupleRead, B: TupleRead {
    (try! ._read(), try! ._read())
  }

  @inlinable
  public static func read<A, B, C>() -> (A, B, C)!
  where A: TupleRead, B: TupleRead, C: TupleRead {
    (try! ._read(), try! ._read(), try! ._read())
  }

  @inlinable
  public static func read<A, B, C, D>() -> (A, B, C, D)!
  where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead {
    (try! ._read(), try! ._read(), try! ._read(), try! ._read())
  }

  @inlinable
  public static func read<A, B, C, D, E>() -> (A, B, C, D, E)!
  where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead {
    (try! ._read(), try! ._read(), try! ._read(), try! ._read(), try! ._read())
  }

  @inlinable
  public static func read<A, B, C, D, E, F>() -> (A, B, C, D, E, F)!
  where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead, F: TupleRead {
    (try! ._read(), try! ._read(), try! ._read(), try! ._read(), try! ._read(), try! ._read())
  }
}

extension Array where Element: RawRepresentable, Element.RawValue == UInt8 {
  @inlinable
  static func read(columns: Int) -> [Element] {
    [UInt8].read(columns: columns)
      .compactMap(Element.init)
  }
}

extension Array
where Element: Sequence, Element.Element: RawRepresentable, Element.Element.RawValue == UInt8 {
  @inlinable
  static func read(rows: Int, columns: Int) -> [[Element.Element]] {
    [[UInt8]].read(rows: rows, columns: columns)
      .map {
        $0.compactMap(Element.Element.init)
      }
  }
}
