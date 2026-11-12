
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
