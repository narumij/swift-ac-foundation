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
extension UInt: FullRead { }
extension Double: FullRead { }
extension CInt: FullRead { }
extension CUnsignedInt: FullRead { }
extension CLongLong: FullRead { }
extension CUnsignedLongLong: FullRead { }

extension String: TupleRead { }
extension CChar: TupleRead { }

public extension FixedWidthInteger {
    @inlinable @inline(__always) static func read() -> Self! { .init(SCANL.next()!) }
}

public extension BinaryFloatingPoint {
    @inlinable @inline(__always) static func read() -> Self! { .init(SCANF.next()!) }
}

public extension String {
    @inlinable @inline(__always) static func read() -> String! { readLine() }
    
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
    @inlinable @inline(__always) static func read() -> [CChar] { ATOC.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [CChar] { ATOC.read(columns: columns) }
}

public extension Array where Element == Array<CChar> {
    
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[CChar]] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

// MARK: -

@usableFromInline protocol IOReaderInstance: IteratorProtocol {
    static var instance: Self { get set }
}

extension IOReaderInstance {
    @inlinable @inline(__always) static func next() -> Element! { instance.next() }
}

@usableFromInline protocol IOReader { }

@usableFromInline protocol ScanfIOReader: IOReader {
    associatedtype Element: ExpressibleByIntegerLiteral
    var format: String { get }
}

extension ScanfIOReader {
    
    @inlinable @inline(__always)
    mutating func _next() -> Element? {
        func __vfscanf(_ file: UnsafeMutablePointer<FILE>!,_ format: String, _ args: CVarArg...) -> Int32 {
            withVaList(args) { vaList in vfscanf(stdin, format, vaList) }
        }
        var element: Element = 0
        let result = withUnsafeMutablePointer(to: &element) { arg in
            __vfscanf(stdin, format, arg)
        }
        assert(result != EOF)
        assert(result != 0)
        if result == EOF { return nil }
        if result == 0 { return nil }
        defer { getchar_unlocked() }
        return element
    }
}

@usableFromInline struct SCANL: IteratorProtocol, ScanfIOReader, IOReaderInstance {
    public typealias Element = CLongLong
    public var format: String = "%lld"
    public static var instance = Self()
    @inlinable @inline(__always)
    public mutating func next() -> Element? { _next() }
}

@usableFromInline struct SCANF: IteratorProtocol, ScanfIOReader, IOReaderInstance {
    public typealias Element = CDouble
    public var format: String = "%lf"
    public static var instance = Self()
    @inlinable @inline(__always)
    public mutating func next() -> Element? { _next() }
}

// MARK: -

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
    static func __readBytes(count: Int) -> Self {
        return [.__readHead()] + (1..<count).map { _ in
            numericCast(getchar_unlocked())
        }
    }
}

// MARK: -

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
            buffer[current] = numericCast(getchar_unlocked())
        }
        return buffer.withUnsafeBufferPointer{ f($0, current) }
    }
}

@usableFromInline struct ATOC: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer: [CChar] = .init(repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Array<CChar>? { _next { Array($0[0..<$1]) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read() -> [CChar] {
        var buffer: [CChar] = [.__readHead()]
        while buffer.last != .SP, buffer.last != .LF, buffer.last != 0 {
            buffer.append(numericCast(getchar_unlocked()))
        }
        buffer.removeLast()
        return buffer
    }
    @inlinable @inline(__always) static func read(columns: Int) -> [CChar] {
        defer { getchar_unlocked() }
        return .__readBytes(count: columns)
    }
}

@usableFromInline struct ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> String? { _next { b,c in String(bytes: b[0..<c], encoding: .ascii) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> String! {
        defer { getchar_unlocked() }
        return String(bytes: Array.__readBytes(count: columns), encoding: .ascii)
    }
}
