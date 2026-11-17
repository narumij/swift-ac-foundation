import IOBase

// These adapters compare the low-level readers with cin, which leaves every
// terminating byte unread. Public IOReader input consumes a trailing newline.
private func _cinValue<Value>(_ item: (value: Value, separator: UInt8?)) -> Value {
  _ = __ungetc(item.separator)
  return item.value
}

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
    _cinValue(try _atol<Self>.read())
  }
  
  public static var stdin: Self {
    try! read()
  }
}

extension Int32 {

  public static func read() throws -> Self {
    _cinValue(try _atol<Self>.read())
  }
  
  public static var stdin: Self {
    try! read()
  }
}

extension Int64 {

  public static func read() throws -> Self {
    _cinValue(try _atol<Self>.read())
  }
  
  public static var stdin: Self {
    try! read()
  }
}

extension UInt {

  public static func read() throws -> Self {
    _cinValue(try _atoul<Self>.read())
  }

  public static var stdin: Self {
    try! read()
  }
}

extension UInt32 {

  public static func read() throws -> Self {
    _cinValue(try _atoul<Self>.read())
  }

  public static var stdin: Self {
    try! read()
  }
}

extension UInt64 {

  public static func read() throws -> Self {
    _cinValue(try _atoul<Self>.read())
  }

  public static var stdin: Self {
    try! read()
  }
}

@available(macOS 15.0, *)
extension Int128 {

  public static var stdin: Self {
    _cinValue(try! _atol.read())
  }
}

@available(macOS 15.0, *)
extension UInt128 {

  public static var stdin: Self {
    _cinValue(try! _atoul.read())
  }
}

extension Double {

  public static func read() throws -> Self {
    _cinValue(try _atof.read())
  }
}

extension String {

  public static func read() throws -> Self {
    _cinValue(try _atos.read())
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
    _cinValue(try _atob.read())
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
    _cinValue(try _atoc.read())
  }

  public static func read(columns: Int) throws -> Self {
    try _atoc.read(count: columns)
  }

  public static var stdin: Self {
    try! .read()
  }
}
