import Pack

/// びっくり！です
@inlinable
public func factorial<Number>(_ n: Number) -> Number
where Number: Numeric & Hashable & ExpressibleByIntegerLiteral & Comparable {

  var memo: [Pack<Number>: Number] = .init()

  func factorial(_ n: Number) -> Number {
    let args = Pack(n)
    if let result = memo[args] {
      return result
    }
    let r = body(n)
    memo[args] = r
    return r
  }

  func body(_ n: Number) -> Number {
    n <= 1 ? 1 : n * factorial(n - 1)
  }

  return factorial(n)
}
