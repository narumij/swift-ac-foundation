import IOReaderV2
import IOBase

public protocol IOConversionReadable: Component & Numeric {
  static func _readWithSeparator() throws -> (value: Self, separator: UInt8?)
}

extension IOConversionReadable {
  
  public static var stdin: Self {
    try! _readWithSeparator().value
  }
  
  public static func read() throws -> Self {
    try _readWithSeparator().value
  }

  public static func lineIterator() -> IOBase.LineIterator<Self> {
    makeLineIterator { try Self._readWithSeparator() }
  }
  
  public static func lineIterator(columns: Int) -> AnyIterator<Self> {
    var columns = columns
    return AnyIterator {
      defer { columns -= 1 }
      return columns > 0 ? try! Self._readWithSeparator().value : nil
    }
  }
}

public protocol IOIntegerConversionReadable: IOConversionReadable {
  static func convert(from: Int) -> Self
}

public protocol IOUnsignedIntegerConversionReadable: IOConversionReadable {
  static func convert(from: UInt) -> Self
}

public protocol IODoubleConversionReadable: IOConversionReadable {
  static func convert(from: Double) -> Self
}

public protocol IOStringConversionReadable: IOConversionReadable {
  static func convert(from: String) -> Self
}

public protocol IOBytesConversionReadable: IOConversionReadable {
  static func convert(from: [UInt8]) -> Self
}

// MARK: -

extension IOIntegerConversionReadable {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atol.read { convert(from: $0) }
  }
}

extension IOUnsignedIntegerConversionReadable {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atoul.read { convert(from: $0) }
  }
}

extension IODoubleConversionReadable {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atof.read { convert(from: $0) }
  }
}

extension IOStringConversionReadable {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atos.read { convert(from: $0) }
  }
}

extension IOBytesConversionReadable {

  public static func _readWithSeparator() throws -> (value: Self, separator: UInt8?) {
    try _atob.read { convert(from: $0) }
  }
}
