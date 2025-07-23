import Foundation

struct IndexHelper2D {
  public init(_ width: Int,_ height: Int) {
    self.width = width
    self.height = height
  }
  let width: Int
  let height: Int
  @inlinable
  var count: Int {
    return width * height
  }
  @inlinable
  subscript(x: Int, y: Int, z: Int) -> Int {
    x + y * width
  }
}

struct IndexHelper3D {
  public init(_ width: Int,_ height: Int,_ depth: Int) {
    self.width = width
    self.height = height
    self.depth = depth
  }
  let width: Int
  let height: Int
  let depth: Int
  @inlinable
  var count: Int {
    return width * height * depth
  }
  @inlinable
  subscript(x: Int, y: Int, z: Int) -> Int {
    x + y * width + z * width * height
  }
}
