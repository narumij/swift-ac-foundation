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
  
  static func stdin(rows: Int) -> [Self] {
    (0..<rows).map { _ in .stdin }
  }
}

extension SIMD2: Group where Scalar: Component {
  
  static var stdin: Self {
    .init(.stdin, .stdin)
  }
}

extension SIMD3: Group where Scalar: Component {
  
  static var stdin: Self {
    .init(.stdin, .stdin, .stdin)
  }
}

@available(macOS 14.0.0, *)
extension Pack: Group where repeat each T: Component {
  
  static var stdin: Pack<repeat each T> {
    .init(repeat (each T).stdin)
  }
}
