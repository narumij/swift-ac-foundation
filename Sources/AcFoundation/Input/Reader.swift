import Foundation

public protocol SingleRead {
    @inlinable @inline(__always)
    static func read() -> Self!
}

public protocol TupleRead: SingleRead { }
public protocol ArrayRead: SingleRead { }
public protocol FullRead: ArrayRead & TupleRead { }

public extension Collection where Element: ArrayRead {
    @inlinable @inline(__always)
    static func read(columns: Int) -> [Element] {
        (0..<columns).map{ _ in Element.read() }
    }
    @inlinable @inline(__always)
    static func read(rows: Int) -> [Element] {
        (0..<rows).map{ _ in Element.read() }
    }
}

public extension Collection where Element: Collection, Element.Element: ArrayRead {
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[Element.Element]] {
        (0..<rows).map{ _ in Element.read(columns: columns) }
    }
}

extension Int: FullRead { }
extension Double: FullRead { }
extension CInt: FullRead { }
extension CUnsignedInt: FullRead { }
extension CLongLong: FullRead { }
extension CUnsignedLongLong: FullRead { }

extension String: TupleRead { }
extension CChar: TupleRead { }

public extension FixedWidthInteger {
    @inlinable @inline(__always) static func read() -> Self! { .init(ATOL.read()!) }
}

public extension BinaryFloatingPoint {
    @inlinable @inline(__always) static func read() -> Self! { .init(ATOF.read()!) }
}

public extension String {
    @inlinable @inline(__always) static func read() -> String! { ATOS.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> String! { ATOS.read(columns: columns) }
}

public extension Array where Element == String {
    
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [String] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

public extension CChar {
    static func read() -> CChar! { ATOC.read(columns: 1).first! }
}

public extension Array where Element == CChar {
    @inlinable @inline(__always) static func read() -> Self! { ATOC.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [CChar]! { ATOC.read(columns: columns) }
}

public extension Array where Element == Array<CChar> {
    
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[CChar]] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

@usableFromInline protocol IOReader { }

@usableFromInline protocol FixedBufferIOReader: IOReader {
    var buffer: [UInt8] { get set }
}

extension FixedBufferIOReader {
    
    @inlinable @inline(__always)
    mutating func _next<T>(_ f: (UnsafePointer<UInt8>) -> T) -> T? {
        let SP: UInt8 = 0x20
        let LF: UInt8 = 0x0A
        var current = 0
        return buffer.withUnsafeMutableBufferPointer { buffer in
            repeat {
                let c = getchar_unlocked()
                buffer[current] = c < 0 ? LF : UInt8(c)
            } while buffer[current] == SP || buffer[current] == LF;
            if buffer[current] == LF { return nil }
            while buffer[current] != SP, buffer[current] != LF {
                current += 1
                let c = getchar_unlocked()
                buffer[current] = c < 0 ? LF : UInt8(c)
            }
            return current == 0 ? nil : f(buffer.baseAddress!)
        }
    }
}

@usableFromInline protocol VariableBufferIOReader: IOReader {
    associatedtype BufferElement: FixedWidthInteger
    var buffer: [BufferElement] { get set }
}

extension VariableBufferIOReader {
    @inlinable @inline(__always)
    mutating func _next<T>(_ f: (UnsafeBufferPointer<BufferElement>, Int) -> T?) -> T? {
        let SP: BufferElement = 0x20
        let LF: BufferElement = 0x0A
        var current = 0
        repeat {
            let c = getchar_unlocked()
            buffer[current] = c < 0 ? LF : BufferElement(c)
        } while buffer[current] == SP || buffer[current] == LF;
        while buffer[current] != SP, buffer[current] != LF {
            current += 1
            if current == buffer.count {
                buffer.append(contentsOf: repeatElement(0, count: buffer.count))
            }
            let c = getchar_unlocked()
            buffer[current] = c < 0 ? LF : BufferElement(c)
        }
        return buffer.withUnsafeBufferPointer{ f($0, current) }
    }
}

@usableFromInline protocol IOReaderInstance: IteratorProtocol {
    static var instance: Self { get set }
}

extension IOReaderInstance {
    @inlinable @inline(__always) static func read() -> Element! { instance.next() }
}

@usableFromInline struct ATOL: IteratorProtocol, FixedBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Int? { _next { atol($0) } }
    public static var instance = Self()
}

@usableFromInline struct ATOF: IteratorProtocol, FixedBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 64)
    @inlinable @inline(__always)
    public mutating func next() -> Double? { _next { atof($0) } }
    public static var instance = Self()
}

@usableFromInline struct ATOC: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer: [CChar] = .init(repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Array<CChar>? { _next { Array($0[0..<$1]) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> [CChar] {
        let SP: CChar = 0x20
        let LF: CChar = 0x0A
        var head = LF
        repeat {
            head = CChar(truncatingIfNeeded: getchar_unlocked())
        } while head == SP || head == LF;
        return [head] + (1..<columns).map { _ in CChar(truncatingIfNeeded: getchar_unlocked()) }
    }
}

@usableFromInline struct ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> String? { _next { b,c in String(bytes: b[0..<c], encoding: .ascii) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> String! {
        let SP: UInt8 = 0x20
        let LF: UInt8 = 0x0A
        var head = LF
        repeat {
            head = UInt8(truncatingIfNeeded: getchar_unlocked())
        } while head == SP || head == LF;
        return String(bytes: [head] + (1..<columns).map { _ in UInt8(truncatingIfNeeded: getchar_unlocked()) },
               encoding: .ascii)
    }
}
