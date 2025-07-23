import Foundation

/// Swiftの多重配列の遅さへの対策の一つです
public struct IndexHelper2D {
  public init(_ width: Int,_ height: Int) {
    self.width = width
    self.height = height
  }
  @usableFromInline let width: Int
  @usableFromInline let height: Int
  @inlinable
  public var count: Int {
    return width * height
  }
  @inlinable
  public subscript(x: Int, y: Int, z: Int) -> Int {
    x + y * width
  }
}

/// Swiftの多重配列の遅さへの対策の一つです
public struct IndexHelper3D {
  public init(_ width: Int,_ height: Int,_ depth: Int) {
    self.width = width
    self.height = height
    self.depth = depth
  }
  @usableFromInline let width: Int
  @usableFromInline let height: Int
  @usableFromInline let depth: Int
  @inlinable
  public var count: Int {
    return width * height * depth
  }
  @inlinable
  public subscript(x: Int, y: Int, z: Int) -> Int {
    x + y * width + z * width * height
  }
}
