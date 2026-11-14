import IOReader
import Pack

@available(macOS 14.0.0, *)
extension Pack: IOConversion, Group where repeat each T: Component {
  
  @inlinable
  public static func read() throws -> Self {
    var remaining = 0
    for _ in repeat (each T).self { remaining += 1 }
    func read<U: Component>(_: U.Type) throws -> U {
      remaining -= 1
      return try _readGroupElement(last: remaining == 0)
    }
    return .init(repeat try read((each T).self))
  }
}

// MARK: -

extension Pack2: IOConversion, Group where T: Component, U: Component {

  @inlinable
  public static func read() throws -> Self {
    .init(rawValue: try readTuple())
  }
}

extension Pack3: IOConversion, Group where T: Component, U: Component, V: Component {

  @inlinable
  public static func read() throws -> Self {
    .init(rawValue: try readTuple())
  }
}

extension Pack4: IOConversion, Group where T: Component, U: Component, V: Component, W: Component {

  @inlinable
  public static func read() throws -> Self {
    .init(rawValue: try readTuple())
  }
}
