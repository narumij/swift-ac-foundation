@preconcurrency import _FastIO

public struct InputConfiguration {

  nonisolated(unsafe) public static var shared = InputConfiguration() {
    didSet {
      let result = _set_fastio_uses_pending_character(shared.usesPendingCharacter ? 1 : 0)
      precondition(result == 0, "Failed to restore pending input character")
      _fastio_integer_mode = FastIOIntegerMode(shared.integerMode.rawValue)
      _fastio_floating_point_mode = FastIOFloatingPointMode(shared.floatingPointMode.rawValue)
    }
  }

  public enum IntegerMode: UInt32 {
    /// 0x/0Xは16進、先頭0は8進、それ以外は10進。
    case auto = 0
    /// autoに0b/0Bの2進判別を加える。
    // TODO(ATCODER-004): auto2の名前を再検討する。autoWithBinaryは候補で、採用は保留。
    case auto2 = 1
    case binary = 2
    case octal = 8
    case decimal = 10
    case hexadecimal = 16
  }

  public enum FloatingPointMode: UInt32 {
    // TODO(ATCODER-004): specificとgccLikeの名前を再検討する。decimal等の案は未採用。
    case specific = 0
    case libcxx = 1
    case gccLike = 2
  }

  public var integerMode: IntegerMode
  public var floatingPointMode: FloatingPointMode

  /// trueなら内部の1文字バッファ、falseなら標準のungetcを使う。
  public var usesPendingCharacter: Bool

  private init() {
    integerMode = IntegerMode(rawValue: _fastio_integer_mode.rawValue)!
    floatingPointMode = FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!
    usesPendingCharacter = _use_fastio_pending_character != 0
  }
}
