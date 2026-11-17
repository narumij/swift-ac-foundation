# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

`Misc (#35)`と`Develop/misc/0 (#41)`のsquashマージ、およびその後の修正を、0.1.34からの差分としてまとめています。

### Added

- `IOBase`ターゲットを追加し、cin互換の低レベル入力部品をIOReaderから分離
- `InputConfiguration`を追加し、整数入力モード（`auto`/`auto2`/`binary`/`octal`/`decimal`/`hexadecimal`）と浮動小数点入力モード（`specific`/`libcxx`/`gccLike`）を実行時に選択可能に変更
- `IOConfig.BufferPolicy`を追加し、IOReaderの可変長バッファ容量を制御可能に変更
- IOReaderに`Component`/`Group`/`IOConversion`を追加し、`IOConversion`に準拠して`read()`を実装した型を読み取れるように変更
- IOReaderに`lineIterator`/`wordIterator`と`readTuple()`を追加
- `Int128`と`UInt128`のIOReader対応を追加（macOS 15.0以降）
- `SIMD2`/`SIMD3`/`SIMD4`と`InlineArray`のIOReader対応を追加（1行に並んだ値として読み取り。`SIMD`はタプルの要素にも使用可能）
- `IOReaderExtra`ターゲットを追加し、`Pack`/`Pack2`/`Pack3`/`Pack4`のIOReader対応を追加
- `Pack4`を追加
- `IOWriter`ターゲットを追加し、`Sequence`/`InlineArray`向けの`print`と`putchar_unlocked`（`Character`）を追加
- `IOWriter`に`PrintableElement`を追加し、準拠した型の`Sequence`でも`print`を使えるように変更（`CustomStringConvertible`な型は`printableDescription`の実装を省略可能）
- `IOUtil`に`Sequence`/`Collection`/`InlineArray`向けの`fastPrint`補助を追加
- `TestingUtil`ターゲットとライブラリプロダクトを追加し、テスト用ヘルパーをライブラリ側へ移動
- `TestingUtilTests`ターゲットを追加し、`SolverRunner`、`StdoutSilencer`、標準入力リダイレクトのテストを追加
- `BENCHMARK`と`ENABLE_DEATH_TESTS`のパッケージtraitを追加
- `UInt8`に`isASCII`、`isAlphabet`、`isDigit`を追加
- `UInt8`のシーケンス向けに`joined()`を追加
- `StringProtocol`にInt添字を追加し、`Substring`でもInt添字を使えるように変更
- CIにAddress Sanitizer/Thread Sanitizerのジョブを追加し、通常テストをdebug/releaseに分割

### Changed

- IOReaderを全面的に作り直し（旧`IOReaderV2`を`IOReader`の名前で置き換え）
- IOReaderの`columns`指定は値が1行に並んでいること、`rows`指定は1行に値または組が1つであることを前提にし、合わない入力では読んだ値と次の文字を示すメッセージを出して停止するように変更
- IOReaderの`readLine()`をthrowsもOptionalも返さない形に変更
- 入力エラーメッセージを英語に変更
- タプル読み取りの要素プロトコルを`TupleReadable`から`Component`へ変更
- `MT19937`ターゲットを`CxxMT19937`へリネーム
- `CxxWrapped`ターゲットを`CxxMath`へリネーム
- `AcFoundation`が`IOReaderExtra`も再エクスポートするように変更
- `withUnsafeReadLineBytes`を`IOUtil`から`IOBase`へ移動し、IOReaderの`IOUtil`依存を解消
- `[Character]`/`[UInt8]`を返す`readLine(strippingNewline:)`を`_FastIO`ベースの実装へ変更し、`IOUtil`のグローバル関数へ移動
- `putchar_unlocked`（`UInt8`）を`IOUtil`へ移動
- IOReader内部の`Error`を`IOReaderError`へリネームし、`IOBase`へ移動
- `UInt8`の`isWholeNumber`/`wholeNumberValue`がASCIIの0–9だけを対象とすることをドキュメントに明記（Latin-1の上付き数字は対象外）
- Swift tools versionを6.2へ更新し、Packageのplatform指定を外す方向へ調整
- テストターゲットを機能別に分割し、旧`AcFoundationTests`配下のテストを各モジュール用ターゲットへ移動
- `fastPrint`の引数名を`terminater`から`terminator`へ修正し、旧APIを削除
- `fastPrint`の整数型制約を`FastPrintableInteger`へ変更し、対応型を`Int`/`UInt`と16/32/64bit整数に限定
- `String.init(ascii:)`を削除し、`String.init(asciiValues:)`へ一本化
- `Pack`にmacOS 14.0以降のavailabilityを付与
- CI対象ブランチに`compatible/AtCoder/2025`を追加

### Removed

- 外部パッケージへの依存（swift-algorithms、BigInt）をすべて削除
- `Miscellaneous`ターゲットと`Convenience`ターゲットを削除
- IOReaderのthrowsする`read`系API（`read(columns:)`、`read(rows:)`、`read(rows:columns:)`、グローバルの`read()`など）を削除
- `IOUtilError`を削除（`IOReaderError.unexpectedEOF`を使用）
- `IndexHelper2D`、`TransposedIndexHelper2D`、`IndexHelper3D`を削除
- `FileOutputStream`を削除
- `IOUtil`の実験的な`readIntLine`/`readUIntLine`系APIを削除

### Fixed

- `CxxMT19937.mt19937_64`のコピー同士で乱数生成器の状態が共有され、片方の`next()`や`discard(_:)`がもう片方の乱数列も進める問題を修正。C++の`std::mt19937_64`を引き続き使用し、更新前に現在の状態を複製するCopy-on-Writeを導入。別々のコピーを並行利用した際の共有状態への書き込み競合にも対処
- `geline.swift`を`getline.swift`へリネーム
- IOReaderの可変長バッファが大きくなり続ける問題を修正
- `stderr`/`stdout`向け`FILE`ポインタの`TextOutputStream`対応を復帰
- `InlineArray.fastPrint`の符号なし整数出力で符号付き出力関数を使っていた問題を修正

## [0.1.34] - 2025-9-23

### Added

- `Pack2`と`Pack3`を追加

## [0.1.33] - 2025-9-14

### Added

- `getline`、`readIntLine`、`readUIntLine`を追加
- `Character`と`UInt8`の`readLine(strippingNewline:)`を追加

### Changed

- `_FastPrint`を`_FastIO`へ統合し、行読み込み用のC実装を追加

## [0.1.32] - 2025-9-4

### Added

- `mt19937_64`に`Sendable`適合を追加

## [0.1.31] - 2025-9-3

### Added

- `Pack`に`Sendable`適合を追加

## [0.1.30] - 2025-8-30

### Added

- `FileOutputStream`を追加
- `fastPrint`にASCII配列と`Character`配列の出力を追加

### Changed

- `Foundation`の`@preconcurrency` importを通常のimportへ変更

## [0.1.29] - 2025-8-15

### Added

- `StringUtil`ターゲットと`String`の整数添字アクセスを追加
- `mt19937_64`乱数生成器を追加
- `IndexHelper2D`の座標変換と転置用ヘルパーを追加

### Changed

- C/C++系ターゲットの公開ヘッダ設定とリリースビルド設定を調整

## [0.1.28] - 2025-8-3

### Changed

- READMEを更新

## [0.1.27] - 2025-8-3

### Changed

- Package設定とREADMEを更新

## [0.1.25] - 2025-7-30

### Changed

- IOReaderの整数読み取り実装を整理
- `_FastPrint`関連のヘッダ構成を調整

## [0.1.24] - 2025-7-30

### Added

- `_FastPrint`ターゲットを追加し、`fastPrint`の整数出力をC実装へ移行

### Changed

- C++ラップ用ターゲット名を`_cxx`へ変更
- BigIntの依存バージョンを5.7.0へ更新

## [0.1.23] - 2025-7-28

### Added

- `Array`と`ArraySlice`の`resize`を追加
- `UInt8`の文字種判定、ASCII変換、`putchars_unlocked`を追加
- `IndexHelper2D`と`IndexHelper3D`を追加

### Changed

- IOReaderのバッファ処理を可変長バッファ方式へ変更
- `Convenience`ターゲット名のスペルを修正
- `bisect`系APIなどに`@inline(__always)`を追加

## [0.1.22] - 2025-6-27

### Added

- `CharacterUtil`、`UInt8Util`、`Miscellaneous`、`Convenience`ターゲットを追加
- `Character`と`UInt8`列の比較演算を追加
- 競技プログラミング向けの補助関数、定数、配列生成、累積和、範囲演算、SIMD補助を追加

## [0.1.21] - 2025-6-22

### Added

- `Pack`の`SingleReadable`適合を追加
- タプル読み取り用の`read`と`stdin`を公開

### Changed

- `LineReadable.readLine()`を`throws`に変更

## [0.1.20] - 2025-6-21

### Changed

- PackにCustomStringConvertible等を追加

## [0.1.19] - 2025-6-21

## [0.1.18] - 2025-6-21

### Added

- gcd関数とlcm暗数を追加

## [0.1.17] - 2025-6-20

### Added

- Packを追加

## [0.1.14] - 2025-5-18

## [0.1.13] - 2025-5-18

## [0.1.12] - 2025-5-18

### Changed

- IOReader関連プロトコルの継承階層を変更

### Added

- タプルを読む関数を追加

## [0.1.11] - 2025-5-18

### Changed

- IOReader関連プロトコルの継承階層を変更
- IOReaderのUIntのプロトコル適合方法を変更
- Intのメソッド呼び出し階層を短絡化する修正

### Removed

- IOReaderのUIntのプロトコル適合を削除
- デリミタの消費を選択できるreadメソッドを削除

## [0.1.10] - 2025-5-17

### Removed

- CI対応でInt128のテストコードを削除

## [0.1.9] - 2025-5-17

### Added

- IOUtilにfastPrintを追加

## [0.1.8] - 2025-5-14

### Changed

- Package名をswift-ac-foundationに変更

## [0.1.7] - 2025-5-12

### Changed

- コメントドキュメントの修正

## [0.1.6] - 2025-5-11

### Changed

- Foundationのpreconcurrencyでのエキスポートを復帰

## [0.1.5] - 2025-5-11

### Removed

- Foundationのpreconcurrencyでのエキスポートを除去

## [0.1.4] - 2025-5-11

### Changed

- read()等メソッドの戻り値を変更
- 区切り文字に水平タブと復帰を追加
- 一部のread()の実装からforce unwrapを除去する変更

### Added

- readLine()メソッドを追加
- Foundationのpreconcurrencyでのエキスポートを追加

## [0.1.3] - 2025-5-5

### Fixed

- 末尾がEOFだった場合に、クラッシュ又は動作停止となる不具合の修正
- 内部でforce unwrapしていた一部のreadメソッドを例外付きに変更

## [0.1.2] - 2025-5-4

### Added

- stdinプロパティのデフォルト実装を追加

## [0.1.0] - 2025-1-18

- ジャッジ用の初期バージョン
