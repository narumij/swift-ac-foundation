import Foundation

extension Double: IOReadableFloatingPoint {}

public protocol IOReadableFloatingPoint: IODoubleConversionReadable where Self: BinaryFloatingPoint { }

extension IOReadableFloatingPoint {
  @inlinable
  @inline(__always)
  public static func convert(from: Double) -> Self {
    Self(from)
  }
}
