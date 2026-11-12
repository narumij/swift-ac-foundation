@preconcurrency import _FastIO

public struct InputConfiguration {

  nonisolated(unsafe) public static var shared = InputConfiguration() {
    didSet {
      shared.store()
    }
  }

  public var integerMode: IntegerMode
  public var floatingPointMode: FloatingPointMode

  /// trueなら内部の1文字バッファ、falseなら標準のungetcを使う。
  public var usesPendingCharacter: Bool
  
  mutating func fetch() {
    integerMode = IntegerMode(rawValue: _fastio_integer_mode.rawValue)!
    floatingPointMode = FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!
    usesPendingCharacter = _use_fastio_pending_character != 0
  }
  
  func store() {
    let result = _set_fastio_uses_pending_character(usesPendingCharacter ? 1 : 0)
    precondition(result == 0, "Failed to restore pending input character")
    _fastio_integer_mode = FastIOIntegerMode(integerMode.rawValue)
    _fastio_floating_point_mode = FastIOFloatingPointMode(floatingPointMode.rawValue)
  }
  
  public static func restoreCache() {
    _restore_stdin()
  }

  private init() {
    integerMode = IntegerMode(rawValue: _fastio_integer_mode.rawValue)!
    floatingPointMode = FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!
    usesPendingCharacter = _use_fastio_pending_character != 0
  }
}
