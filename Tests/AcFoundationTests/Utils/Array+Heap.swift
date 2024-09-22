import Foundation

extension Array {
    
    @inlinable
    public mutating func heappush(_ element:Element)
    where Element: Comparable
    {
        heappush(Comparer_A.self, element)
    }
    
    @inlinable
    public mutating func heappop() -> Element?
    where Element: Comparable
    {
        heappop(Comparer_A.self)
    }
    
    @inlinable
    public mutating func heappush<A,B>(_ element:Element)
    where Element == (A,B),
          A: Comparable,
          B: Comparable
    {
        heappush(Comparer_A_B<A,B>.self, element)
    }
    
    @inlinable
    public mutating func heappop<A,B>() -> Element?
    where Element == (A,B),
          A: Comparable,
          B: Comparable
    {
        heappop(Comparer_A_B<A,B>.self)
    }
    
    @inlinable
    public mutating func heappush<A,B,C>(_ element:Element)
    where Element == (A,B,C),
          A: Comparable,
          B: Comparable,
          C: Comparable
    {
        heappush(Comparer_A_B_C<A,B,C>.self, element)
    }
    
    @inlinable
    public mutating func heappop<A,B,C>() -> Element?
    where Element == (A,B,C),
          A: Comparable,
          B: Comparable,
          C: Comparable
    {
        heappop(Comparer_A_B_C<A,B,C>.self)
    }
    
    @usableFromInline
    enum Comparer_A: BinaryHeapComparer
    where Element: Comparable
    {
        @inlinable
        public static var __heap_value_compare: (Element, Element) -> Bool { (<) }
    }
    
    @usableFromInline
    enum Comparer_A_B<A,B>: BinaryHeapComparer where A: Comparable, B: Comparable {
      @inlinable
      static var __heap_value_compare: (Element, Element) -> Bool { (<) }
      @usableFromInline
      typealias Element = (A,B)
    }
    
    @usableFromInline
    enum Comparer_A_B_C<A,B,C>: BinaryHeapComparer where A: Comparable, B: Comparable, C: Comparable {
      @inlinable
      static var __heap_value_compare: (Element, Element) -> Bool { (<) }
      @usableFromInline
      typealias Element = (A,B,C)
    }
}

public protocol BinaryHeapComparer {
    associatedtype Element
    static var __heap_value_compare: (Element, Element) -> Bool { get }
}

extension Array {
    
    @inlinable
    public mutating func heappush<Comp>(_ type: Comp.Type, _ element:Element)
    where Comp: BinaryHeapComparer, Self.Element == Comp.Element
    {
        append(element)
        __update_binary_heap(Comp.self) { $0.push_heap($0.endIndex) }
    }
    
    @inlinable
    public mutating func heappop<Comp>(_ type: Comp.Type) -> Element?
    where Comp: BinaryHeapComparer, Self.Element == Comp.Element
    {
        guard !isEmpty else { return nil }
        __update_binary_heap(Comp.self) { $0.pop_heap($0.endIndex) }
        return removeLast()
    }
}

extension Array {
    
    @inlinable @inline(__always)
    mutating func __update_binary_heap<Comp, R>(
        _ type: Comp.Type,
        _ body: (UnsafeHeapHandle<Comp>) -> R
    ) -> R
    where Comp: BinaryHeapComparer, Self.Element == Comp.Element
    {
        let (startIndex, endIndex) = (startIndex, endIndex)
        return withUnsafeMutableBufferPointer {
            body(
                UnsafeHeapHandle<Comp>(
                    $0.baseAddress!,
                    startIndex: startIndex,
                    endIndex: endIndex))
        }
    }
}

@usableFromInline
struct UnsafeHeapHandle<Comparer: BinaryHeapComparer> {
    
    @usableFromInline
    typealias Element = Comparer.Element
    
    @usableFromInline
    typealias Index = Int
    
    @inlinable @inline(__always)
    internal init(_ buffer: UnsafeMutablePointer<Element>,
                  startIndex: Index, endIndex: Index)
    {
        self.buffer = buffer
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    @usableFromInline
    let buffer: UnsafeMutablePointer<Element>
    
    @usableFromInline
    let startIndex: Index
    
    @usableFromInline
    let endIndex: Index
}

extension UnsafeHeapHandle {
    
    @inlinable @inline(__always)
    var __heap_value_compare: (Element, Element) -> Bool {
        Comparer.__heap_value_compare
    }
    
    @inlinable @inline(__always)
    func __parent(_ p: Int) -> Int { (p - 1) >> 1 }
    
    @inlinable @inline(__always)
    func __leftChild(_ p: Int) -> Int { (p << 1) + 1 }
    
    @inlinable
    func push_heap(_ limit: Index) {
        heapifyUp(limit, limit - 1, __heap_value_compare)
    }
    
    @inlinable
    func pop_heap(_ limit: Index) {
        guard limit > 0, startIndex != limit - 1 else { return }
        swap(&buffer[startIndex], &buffer[limit - 1])
        heapifyDown(limit - 1, startIndex, __heap_value_compare)
    }
    
    @inlinable
    func heapifyUp(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        guard i >= startIndex else { return }
        let element = buffer[i]
        var current = i
        while current > startIndex {
            let parent = __parent(current)
            guard !comp(buffer[parent], element) else { break }
            (buffer[current], current) = (buffer[parent], parent)
        }
        buffer[current] = element
    }
    
    @inlinable
    func heapifyDown(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        let element = buffer[i]
        var (current, selected) = (i,i)
        while current < limit {
            let leftChild = __leftChild(current)
            let rightChild = leftChild + 1
            if leftChild < limit,
               comp(buffer[leftChild], element)
            {
                selected = leftChild
            }
            if rightChild < limit,
               comp(buffer[rightChild], current == selected ? element : buffer[selected])
            {
                selected = rightChild
            }
            if selected == current { break }
            (buffer[current], current) = (buffer[selected], selected)
        }
        buffer[current] = element
    }
}
