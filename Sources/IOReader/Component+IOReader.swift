public protocol Component {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}
