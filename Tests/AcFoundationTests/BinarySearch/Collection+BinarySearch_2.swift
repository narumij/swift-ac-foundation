import Foundation


extension Collection where Index == Int {
    
    @inlinable
    func left<T,U>(_ x: T,_ comparer: (U, T) -> Bool,_ key: (Element) -> U) -> Index {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if comparer(key(self[mid]), x) {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    @inlinable
    func right<T,U>(_ x: T,_ comparer: (T, U) -> Bool,_ key: (Element) -> U) -> Index {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if comparer(x, key(self[mid])) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return right
    }
}
