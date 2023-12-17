import Foundation

extension FixedWidthInteger {
    @inlinable @inline(__always) public static func read() -> Self! { .init(ATOL.read()!) }
}

extension BinaryFloatingPoint {
    @inlinable @inline(__always) public static func read() -> Self! { .init(ATOF.read()!) }
}

extension String {
    @inlinable @inline(__always) public static func read() -> String! { ATOS.read() }
}

public extension Array where Element == CChar {
    @inlinable @inline(__always) static func read() -> Self! { ATOC.read() }
}

public protocol IOReader { }

public protocol FixedBufferIOReader: IOReader {
    var buffer: [UInt8] { get set }
}

public extension FixedBufferIOReader {
    
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

public protocol VariableBufferIOReader: IOReader {
    associatedtype BufferElement: BinaryInteger
    var buffer: [BufferElement] { get set }
}

public extension VariableBufferIOReader {
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

public protocol IOReaderInstance: IteratorProtocol {
    static var instance: Self { get set }
}

public extension IOReaderInstance {
    @inlinable @inline(__always) static func read() -> Element! { instance.next() }
}

public struct ATOL: IteratorProtocol, FixedBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 64)
    @inlinable @inline(__always)
    public mutating func next() -> Int? { _next { atol($0) } }
    public static var instance = Self()
}

public struct ATOF: IteratorProtocol, FixedBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 64)
    @inlinable @inline(__always)
    public mutating func next() -> Double? { _next { atof($0) } }
    public static var instance = Self()
}

public struct ATOC: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer: [CChar] = .init(repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Array<CChar>? { _next { Array($0[0..<$1]) } }
    public static var instance = Self()
}

public struct ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> String? { _next { b,c in String(bytes: b[0..<c], encoding: .ascii) } }
    public static var instance = Self()
}
