import _FastIO

@usableFromInline
protocol ZeroBufferIOReader: IOReader {
  associatedtype Element: FixedWidthInteger
}

extension ZeroBufferIOReader {

  @inlinable
  @inline(__always)
  static func _read() throws -> (value: Element, separator: UInt8?) where Element: SignedInteger {
    var c: Element? = try Element.readHead()
    let negative = c == Element.MINUS
    if negative || c == Element.PLUS {
      c = __getchar_unlocked()
    }
    guard c.map(isNumber) == true else {
      _ = _ungetc(c)
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let _c = c, isNumber(_c) {
      let digit = _c - .ZERO
      value = value * 10 + (negative ? -digit : digit)
      c = __getchar_unlocked()
    }
    return (value, c.map { UInt8(truncatingIfNeeded: $0) })
  }

  @inlinable
  @inline(__always)
  static func _read() throws -> (value: Element, separator: UInt8?) where Element: UnsignedInteger {
    var c: Element? = try Element.readHead()
    let negative = c == Element.MINUS
    if negative || c == Element.PLUS {
      c = __getchar_unlocked()
    }
    guard c.map(isNumber) == true else {
      _ = _ungetc(c)
      throw IOReaderError.invalidInteger
    }

    var value: Element = 0
    while let _c = c, isNumber(_c) {
      value = value * 10 + (_c - .ZERO)
      c = __getchar_unlocked()
    }
    return (negative ? 0 &- value : value, c.map { UInt8(truncatingIfNeeded: $0) })
  }
}

// MARK: -

// 固定2・8・16進とAuto／Auto2に共通する、文字列バッファを作らない整数読取り。
// 先頭処理が「符号・読み済みの文字・基数」を決め、積み上げ処理がその続きを読む。
// 固定基数と自動判別の違いは先頭処理に収め、符号付き／符号なしの計算は分ける。
//
// 10進専用のZeroBufferIOReaderは性能上の理由で、このBaseには統合しない。
// Autoが結果として10進を選ぶ場合は、この汎用経路で読む。
// 文字・桁・計算値をElementで扱い、桁ごとの型変換を避ける。
// 戻り値の区切り文字だけ、既存の読取り契約に合わせてUInt8にする。
//
// 対象はASCII入力。EOFは読み済みの文字がないことをnilで表す。
// C++ストリームのfailbitや復帰機構を実装するものではない。
@usableFromInline
protocol ZeroBufferIOReaderBase: IOReader {
  associatedtype Element: FixedWidthInteger
  // 具体的な読取り型が選ぶモード。Cの実行時設定は呼出し元の_atol/_atoulが振り分ける。
  static var integerMode: FastIOIntegerMode { get }
  // firstは既に入力から取り出した文字。先頭0だけで値が成立した場合は区切りでもよい。
  static func readIntegerHead() throws -> (negative: Bool, first: Element?, radix: Element)
  // isElement(c)を満たす文字を0...15の桁値へ変換する。基数内かの判定は別。
  static func element(_ c: Element) -> Element
  // 16進の候補文字かどうか。実際に読める桁かはelement(c) < radixも併せて判定する。
  static func isElement(_ c: Element) -> Bool
}

extension ZeroBufferIOReaderBase {

  // 呼出し側で候補文字と確認済みなので、ここでは範囲検査を繰り返さない。
  // 0x61/0x41はa/A。数字はASCIIの0との差がそのまま桁値になる。
  @inlinable
  @inline(__always)
  static func element(_ c: Element) -> Element {
    if c >= 0x61 { return c - 0x61 + 10 }
    if c >= 0x41 { return c - 0x41 + 10 }
    return c - .ZERO
  }

  @inlinable
  @inline(__always)
  static func isElement(_ c: Element) -> Bool {
    isNumber(c) || (c >= 0x61 && c <= 0x66) || (c >= 0x41 && c <= 0x46)
  }

  // 空白と任意の符号を消費し、必要なら接頭辞を消費して基数を確定する。
  //   Binary: 2進。0b/0Bは任意。      Octal: 8進。接頭辞処理なし。
  //   Hexadecimal: 16進。0x/0Xは任意。
  //   Auto: 0x/0Xなら16進、先頭0なら8進、それ以外は10進。
  //   Auto2: Autoに0b/0Bの2進判別を追加。
  // 固定16進での0bは接頭辞ではなく、通常の16進数字として読む。
  // 先頭0から既に8進に決まった00A0は、後続にAがあっても16進に変更しない。
  //
  // 接頭辞を消費した場合は直後に有効な桁が必要。0x!などは!を押し戻して失敗する。
  // 符号・接頭辞は失敗しても巻き戻さない。最初の空白読みでのEOFはreadHeadに従う。
  @inlinable
  @inline(__always)
  static func readIntegerHead() throws -> (negative: Bool, first: Element?, radix: Element) {
    var c: Element? = try Element.readHead()
    let negative = c == Element.MINUS
    if negative || c == Element.PLUS {
      c = __getchar_unlocked()
    }

    let mode = integerMode
    let automatic = mode == FastIOIntegerAuto || mode == FastIOIntegerAuto2
    // 固定モードのrawValueは基数そのもの。Auto/Auto2の0/1は基数に使わない。
    var radix: Element = automatic ? 10 : Element(mode.rawValue)
    if c == Element.ZERO && (automatic || mode == FastIOIntegerHexadecimal || mode == FastIOIntegerBinary)
    {
      // 先頭0は桁として消費済み。次の文字で接頭辞か、通常の続きかを見分ける。
      if automatic { radix = 8 }
      c = __getchar_unlocked()
      if (automatic || mode == FastIOIntegerHexadecimal) && (c == 0x78 || c == 0x58) {
        radix = 16
        c = __getchar_unlocked()
      } else if (mode == FastIOIntegerAuto2 || mode == FastIOIntegerBinary)
        && (c == 0x62 || c == 0x42)
      {
        radix = 2
        c = __getchar_unlocked()
      } else if c.map({ isElement($0) && element($0) < radix }) != true {
        // 接頭辞ではない先頭0だけでも値は成立する。次の文字は区切りとして返す。
        // 例: Autoの09 → 0と残り9、0b11 → 0と残りb11、0 EOF → 0とnil。
        // _readのループはこの文字を数値に加えず、値0のまま終了する。
        return (negative, c, radix)
      }
    }
    guard c.map({ isElement($0) && element($0) < radix }) == true else {
      _ = _ungetc(c)
      throw IOReaderError.invalidInteger
    }
    return (negative, c, radix)
  }

  // 最初の非数字まで1文字先読みする。ここでは押し戻さず、値と一緒に返す。
  // 値だけを返す上位のreadはvaluePreservingSeparatorで押し戻す。
  // 区切り付きのreadはその文字を消費済みとして受け取る。この契約を変えない。
  //
  // 負数は各桁を引いて積み上げる。正の絶対値を経由しないため、最小値も表現できる。
  // 範囲外の積み上げは通常の演算子のオーバーフロー検査に任せる。
  // 例外化や残りの数字列を最後まで消費する処理は、ここへ追加していない。
  @inlinable
  @inline(__always)
  static func _read() throws -> (value: Element, separator: UInt8?) where Element: SignedInteger {
    var (negative, c, radix) = try readIntegerHead()

    var value: Element = 0
    while let _c = c, isElement(_c), element(_c) < radix {
      let digit = element(_c)
      value = value * radix + (negative ? -digit : digit)
      c = __getchar_unlocked()
    }
    return (value, c.map { UInt8(truncatingIfNeeded: $0) })
  }

  // 符号なしは正の値を積み上げ、負号があれば最後に0 &- valueで符号を反映する。
  // 最後の減算だけが折返し演算。桁の積み上げ自体を折り返す仕様ではない。
  // 区切りの先読み・返却は符号付きと同じ。
  @inlinable
  @inline(__always)
  static func _read() throws -> (value: Element, separator: UInt8?) where Element: UnsignedInteger {
    var (negative, c, radix) = try readIntegerHead()

    var value: Element = 0
    while let _c = c, isElement(_c), element(_c) < radix {
      value = value * radix + element(_c)
      c = __getchar_unlocked()
    }
    return (negative ? 0 &- value : value, c.map { UInt8(truncatingIfNeeded: $0) })
  }
}

@usableFromInline
protocol ZeroBufferIOReader2: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReader2 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerBinary }
}

@usableFromInline
protocol ZeroBufferIOReader8: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReader8 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerOctal }
}

@usableFromInline
protocol ZeroBufferIOReader16: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReader16 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerHexadecimal }
}

@usableFromInline
protocol ZeroBufferIOReaderAuto: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReaderAuto {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerAuto }
}

@usableFromInline
protocol ZeroBufferIOReaderAuto2: ZeroBufferIOReaderBase {}

extension ZeroBufferIOReaderAuto2 {
  @inlinable
  static var integerMode: FastIOIntegerMode { FastIOIntegerAuto2 }
}
