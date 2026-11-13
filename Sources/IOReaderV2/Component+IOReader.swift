import Pack

protocol Component {
  static var stdin: Self { get }
}

extension Int: Component { }
extension String: Component { }

protocol Group {
  static var stdin: Self { get }
}

extension Group {

  static func groups(count: Int) -> AnyIterator<Self> {
    var count = count
    return .init {
      defer { count -= 1 }
      return count > 0 ? .stdin : nil
    }
  }
}

protocol Groups {
  associatedtype Element: Group
  init<S>(_ sequence: S) where S: Sequence, S.Element == Element
}

extension Groups {
  static func stdin(rows: Int) -> Self {
    .init(Element.groups(count: rows))
  }
}

extension Array: Groups where Element: Group {}
extension Set: Groups where Element: Group {}

// MARK: -

extension SIMD where Scalar: Component {

  static var stdin: Self {
    var v = Self()
    for i in v.indices { v[i] = .stdin }
    return v
  }
}

extension SIMD2: Group where Scalar: Component { }
extension SIMD3: Group where Scalar: Component { }
extension SIMD4: Group where Scalar: Component { }

@available(macOS 14.0.0, *)
extension Pack: Group where repeat each T: Component {
  
  static var stdin: Pack<repeat each T> {
    .init(repeat (each T).stdin)
  }
}
