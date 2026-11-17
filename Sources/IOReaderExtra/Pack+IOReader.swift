import IOReader
import Pack

@available(macOS 14.0.0, *)
extension Pack: IOConversion, Group where repeat each T: Component {
  
  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    try readTuple { (value: (repeat each T)) in
      Self(rawValue: (repeat each value))
    }
  }
}

// MARK: -

extension Pack2: IOConversion, Group where T: Component, U: Component {

  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    try readTuple { .init(rawValue: $0) }
  }
}

extension Pack3: IOConversion, Group where T: Component, U: Component, V: Component {

  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    try readTuple { .init(rawValue: $0) }
  }
}

extension Pack4: IOConversion, Group where T: Component, U: Component, V: Component, W: Component {

  @inlinable
  public static func read() throws -> (value: Self, separator: UInt8?) {
    try readTuple { .init(rawValue: $0) }
  }
}
