#include "BufferedInput.h"
#include "InputModeVariables.h"

// キャッシュ値
int _fastio_pending_character = EOF;

// 1文字キャッシュを利用するかどうか
// 知ってる人だけ切り替える方式でいい気はする
int _use_fastio_pending_character = 0;

// 整数入力モード
// 知ってる人だけ切り替える方式でいい気はする
FastIOIntegerMode _fastio_integer_mode = FastIOIntegerDecimal;

// 浮動小数入力モード
// 知ってる人だけ切り替える方式でいい気はする
FastIOFloatingPointMode _fastio_floating_point_mode = FastIOFloatingPointGCCLike;
