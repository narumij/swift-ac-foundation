public enum FloatingPointMode: UInt32 {
  // TODO(ATCODER-004): specificとgccLikeの名前を再検討する。decimal等の案は未採用。
  case specific = 0
  case libcxx = 1
  case gccLike = 2
}
