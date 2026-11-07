import Foundation
@preconcurrency import _FastIO

@usableFromInline
protocol IOReader {}

@usableFromInline
protocol ElementReader: IOReader {
  associatedtype Element
}

@usableFromInline
typealias ReaderItem<Element> = (value: Element, separator: UInt8?)


extension ElementReader {
  @usableFromInline
  typealias Item = ReaderItem<Element>
}

@usableFromInline
protocol StaticIOReader: ElementReader {
  static func read() throws -> Element
  static func read() throws -> Item
}

extension StaticIOReader {

  @inlinable
  @inline(__always)
  public static func read<T>(_ f: (Element) throws -> T) throws -> ReaderItem<T> {
    let (a, b) = try read()
    return (try f(a), b)
  }
}

@usableFromInline
protocol StaticIOSubReader: StaticIOReader {
  static func _read() throws -> Item
}

extension StaticIOSubReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    valuePreservingSeparator(try Self._read())
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try Self._read()
  }
}

@usableFromInline
protocol InstanceIOReader: ElementReader {
  associatedtype Element
  mutating func read() throws -> Element
  mutating func read() throws -> Item
  static var instance: Self { get set }
}

extension InstanceIOReader {

  @inlinable
  @inline(__always)
  public static func read() throws -> Element {
    try instance.read()
  }

  @inlinable
  @inline(__always)
  public static func read() throws -> Item {
    try instance.read()
  }

  @inlinable
  @inline(__always)
  public static func read<T>(_ f: (Element) throws -> T) throws -> ReaderItem<T> {
    let (a, b) = try instance.read()
    return (try f(a), b)
  }
}
