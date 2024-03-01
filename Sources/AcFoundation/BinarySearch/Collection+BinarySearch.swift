import Foundation

// MARK: - Binary Search

extension Range {
    
    func left<Item>(_ x: Item,_ item: (Element) -> Item) -> Element where Item: Comparable, Bound: BinaryInteger {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if item(mid) < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    func right<Item>(_ x: Item,_ item: (Element) -> Item) -> Element where Item: Comparable, Bound: BinaryInteger {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if x < item(mid) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }
}

extension Collection where Index == Int {
    
    func right(_ x: Element, start left: Index, end right: Index) -> Index where Element: Comparable {
        var (left, right) = (left, right)
        while left < right {
            let mid = (left + right) >> 1
            if x < self[mid] {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }
    
    func right<T>(_ x: T, start left: Index, end right: Index,_ key: (Element) -> T) -> Index where T: Comparable {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if x < key(self[mid]) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }

    func left(_ x: Element, start left: Index, end right: Index) -> Index where Element: Comparable {
        var (left, right) = (left, right)
        while left < right {
            let mid = (left + right) >> 1
            if self[mid] < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    func left<T>(_ x: T, start left: Index, end right: Index,_ key: (Element) -> T) -> Index where T: Comparable {
        var (left, right) = (left, right)
        while left < right {
            let mid = (left + right) >> 1
            if key(self[mid]) < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }

    func right(_ x: Element) -> Index where Element: Comparable {
        right(x, start: startIndex, end: endIndex) { $0 }
    }
    
    func left(_ x: Element) -> Index where Element: Comparable {
        left(x, start: startIndex, end: endIndex) { $0 }
    }
}
