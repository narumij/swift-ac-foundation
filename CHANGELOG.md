# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
