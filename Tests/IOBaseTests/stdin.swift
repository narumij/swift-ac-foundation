import IOBase

extension UInt8 {
  
  public static func read() throws -> UInt8 {
    try _atob.read(count: 1).first.unwrap(or: IOReaderError.unexpectedNil)
  }

  public static var stdin: Self {
    try! .read()
  }
}

extension Character {
  
  public static func read() throws -> Character {
    try Character(UnicodeScalar(UInt8.read()))
  }
  
  public static var stdin: Character {
    try! .read()
  }
}

extension Int {

  public static func read() throws -> Self {
    try _atol<Self>.read()
  }
  
  public static var stdin: Self {
    try! read()
  }
}

extension Int32 {

  public static func read() throws -> Self {
    try _atol<Self>.read()
  }
  
  public static var stdin: Self {
    try! read()
  }
}

extension Int64 {

  public static func read() throws -> Self {
    try _atol<Self>.read()
  }
  
  public static var stdin: Self {
    try! read()
  }
}

extension UInt {

  public static func read() throws -> Self {
    try _atoul<Self>.read()
  }

  public static var stdin: Self {
    try! read()
  }
}

extension UInt32 {

  public static func read() throws -> Self {
    try _atoul<Self>.read()
  }

  public static var stdin: Self {
    try! read()
  }
}

extension UInt64 {

  public static func read() throws -> Self {
    try _atoul<Self>.read()
  }

  public static var stdin: Self {
    try! read()
  }
}

@available(macOS 15.0, *)
extension Int128 {

  public static var stdin: Self {
    try! _atol.read()
  }
}

@available(macOS 15.0, *)
extension UInt128 {

  public static var stdin: Self {
    try! _atoul.read()
  }
}

extension Double {

  public static func read() throws -> Self {
    try _atof.read()
  }
}

extension String {

  public static func read() throws -> Self {
    try _atos.read()
  }

  public static func read(columns: Int) throws -> Self {
    try _atos.read(count: columns)
  }

  public static var stdin: Self {
    try! .read()
  }
}

extension Array where Element == UInt8 {
  
  public static func read() throws -> Self {
    try _atob.read()
  }

  public static func read(columns: Int) throws -> Self {
    try _atob.read(count: columns)
  }

  public static var stdin: Self {
    try! .read()
  }
}

extension Array where Element == Character {
  
  public static func read() throws -> Self {
    try _atoc.read()
  }

  public static func read(columns: Int) throws -> Self {
    try _atoc.read(count: columns)
  }

  public static var stdin: Self {
    try! .read()
  }
}
