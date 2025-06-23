import Pack

/// びっくり！です
@inlinable
func factorial<Number>(_ n: Number) -> Number
where Number: Numeric & Hashable & ExpressibleByIntegerLiteral & Comparable
{
  var storage: [Pack<Number>: Number] = .init()
  
  func factorial(_ n: Number) -> Number {
    let args = Pack(n)
    if let result = storage[args] {
      return result
    }
    let r = body(n)
    storage[args] = r
    return r
  }
  
  func body(_ n: Number) -> Number {
    if n <= 1 {
      return 1
    } else {
      return n * factorial(n - 1)
    }
  }
  
  return factorial(n)
}

