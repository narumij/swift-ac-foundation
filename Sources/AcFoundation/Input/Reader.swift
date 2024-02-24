import Foundation

public protocol SingleRead {
    @inlinable @inline(__always)
    static func read() -> Self
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
extension UInt: FullRead { }
extension Double: FullRead { }
extension CInt: FullRead { }
extension CUnsignedInt: FullRead { }
extension CLongLong: FullRead { }
extension CUnsignedLongLong: FullRead { }

extension String: TupleRead { }
extension Character: TupleRead { }
extension UInt8: TupleRead { }

public extension FixedWidthInteger {
    @inlinable @inline(__always) static func read() -> Self { .init(ATOL.read()!) }
}

public extension BinaryFloatingPoint {
    @inlinable @inline(__always) static func read() -> Self { .init(ATOF.read()!) }
}

public extension String {
    @inlinable @inline(__always)
    static func read() -> String { ATOS.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> String { ATOS.read(columns: columns) }
}

public extension Array where Element == String {
    
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [String] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

public extension UInt8 {
    static func read() -> UInt8 { ATOB.read(columns: 1).first! }
}

public extension Array where Element == UInt8 {
    @inlinable @inline(__always)
    static func read() -> [UInt8] { ATOB.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [UInt8] { ATOB.read(columns: columns) }
}

public extension Array where Element == Array<UInt8> {
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[UInt8]] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

public extension Character {
    static func read() -> Character { Character(String.read(columns: 1)) }
}

public extension Array where Element == Character {
    @inlinable @inline(__always)
    static func read() -> [Character] {
        String.read().map{ $0 }
    }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [Character] {
        String.read(columns: columns).map{ $0 }
    }
}

public extension Array where Element == Array<Character> {
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[Character]] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

@usableFromInline protocol IOReader { }

@usableFromInline protocol FixedBufferIOReader: IOReader {
    var buffer: [UInt8] { get set }
}

extension FixedWidthInteger {
    @inlinable @inline(__always) static var SP: Self { 0x20 }
    @inlinable @inline(__always) static var LF: Self { 0x0A }
}

extension FixedWidthInteger {
    
    @inlinable @inline(__always)
    static func __readHead() -> Self {
        var head: Self
        repeat {
            head = numericCast(getchar_unlocked())
        } while head == .SP || head == .LF;
        return head
    }
}

extension Array where Element: FixedWidthInteger {
    
    @inlinable @inline(__always)
    static func __readBytes(count: Int) -> Self? {
        let h: Element = .__readHead()
        guard h != EOF else { return nil }
        return [h] + (1..<count).map { _ in numericCast(getchar_unlocked()) }
    }
}

extension FixedBufferIOReader {
    
    @inlinable @inline(__always)
    mutating func _next<T>(_ f: (UnsafePointer<UInt8>) -> T) -> T? {
        var current = 0
        return buffer.withUnsafeMutableBufferPointer { buffer in
            buffer.baseAddress![current] = .__readHead()
            while buffer.baseAddress![current] != .SP,
                  buffer.baseAddress![current] != .LF,
                  buffer.baseAddress![current] != EOF
            {
                current += 1
                buffer[current] = numericCast(getchar_unlocked())
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
        var current = 0
        buffer[current] = .__readHead()
        while buffer[current] != .SP, buffer[current] != .LF, buffer[current] != 0 {
            current += 1
            if current == buffer.count {
                buffer.append(contentsOf: repeatElement(0, count: buffer.count))
            }
            buffer[current] = BufferElement(truncatingIfNeeded: getchar_unlocked())
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

@usableFromInline struct ATOB: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer: [UInt8] = .init(repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Array<UInt8>? { _next { Array($0[0..<$1]) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> [UInt8] {
        defer { getchar_unlocked() }
        return .__readBytes(count: columns) ?? []
    }
}

@usableFromInline struct ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> String? { _next { b,c in String(bytes: b[0..<c], encoding: .ascii) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> String! {
        defer { getchar_unlocked() }
        return String(bytes: Array.__readBytes(count: columns) ?? [], encoding: .ascii)
    }
}
