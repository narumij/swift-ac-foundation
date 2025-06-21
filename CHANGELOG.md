# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.20] - 2025-6-21
#### Changed
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
#### Changed
- IOReader関連プロトコルの継承階層を変更
### Added
- タプルを読む関数を追加

## [0.1.11] - 2025-5-18
#### Changed
- IOReader関連プロトコルの継承階層を変更
- IOReaderのUIntのプロトコル適合方法を変更
- Intのメソッド呼び出し階層を短絡化する修正
#### Removed
- IOReaderのUIntのプロトコル適合を削除
- デリミタの消費を選択できるreadメソッドを削除

## [0.1.10] - 2025-5-17
#### Removed
- CI対応でInt128のテストコードを削除

## [0.1.9] - 2025-5-17
### Added
- IOUtilにfastPrintを追加

## [0.1.8] - 2025-5-14
#### Changed
- Package名をswift-ac-foundationに変更

## [0.1.7] - 2025-5-12
#### Changed
- コメントドキュメントの修正

## [0.1.6] - 2025-5-11
#### Changed
- Foundationのpreconcurrencyでのエキスポートを復帰

## [0.1.5] - 2025-5-11
#### Removed
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
