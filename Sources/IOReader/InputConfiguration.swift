@preconcurrency import _FastIO

/// 入力設定のSwift側の窓口。生成時にC側の現在値を取り込み、変更をC側へ反映する。
/// 入力処理と同じ排他管理の下で、読取りの合間に変更する。
public final class InputConfiguration {

  nonisolated(unsafe) public static let shared = InputConfiguration()

  /// rawValueはFastIOIntegerModeに対応する。
  public enum IntegerMode: UInt32 {
    /// 0x/0Xは16進、先頭0は8進、それ以外は10進。
    case auto = 0
    /// autoに0b/0Bの2進判別を加える。
    case auto2 = 1
    case binary = 2
    case octal = 8
    case decimal = 10
    case hexadecimal = 16
  }

  /// rawValueはFastIOFloatingPointModeに対応する。
  public enum FloatingPointMode: UInt32 {
    case specific = 0
    case llvm = 1
    case gccLike = 2
  }

  public var integerMode: IntegerMode {
    didSet { _fastio_integer_mode = FastIOIntegerMode(integerMode.rawValue) }
  }

  public var floatingPointMode: FloatingPointMode {
    didSet { _fastio_floating_point_mode = FastIOFloatingPointMode(floatingPointMode.rawValue) }
  }

  /// trueなら内部の1文字バッファ、falseなら標準のungetcを使う。
  public var usesPendingCharacter: Bool {
    didSet { _use_fastio_pending_character = usesPendingCharacter ? 1 : 0 }
  }

  // 初期化ではdidSetが呼ばれないため、C側のデフォルト設定を書き換えない。
  // 生成後にC変数を直接変更した場合、その変更を自動で読み直すものではない。
  private init() {
    integerMode = IntegerMode(rawValue: _fastio_integer_mode.rawValue)!
    floatingPointMode = FloatingPointMode(rawValue: _fastio_floating_point_mode.rawValue)!
    usesPendingCharacter = _use_fastio_pending_character != 0
  }
}
