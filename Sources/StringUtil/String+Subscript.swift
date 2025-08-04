import Foundation

extension String {

  @inlinable
  @inline(__always)
  public subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }

  @inlinable
  @inline(__always)
  public subscript<R>(_subscript bounds: R) -> Substring where R: RangeExpression, R.Bound == Int {
    let bounds = bounds.relative(to: (0..<self.count))
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ..< end]
  }
  
  @inlinable
  @inline(__always)
  public subscript<R>(bounds: R) -> String where R: RangeExpression, R.Bound == Int {
    String(self[_subscript: bounds])
  }
}
