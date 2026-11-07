public enum IOConfig {
  nonisolated(unsafe)
    public static var bufferPolicy = BufferPolicy.default
}

extension IOConfig {

  public struct BufferPolicy {
    public var minCapacity: Int
    public var maxCapacity: Int
    public static var `default`: BufferPolicy {
      BufferPolicy(
        minCapacity: 16,
        maxCapacity: 1 << 20
      )
    }
  }
}
