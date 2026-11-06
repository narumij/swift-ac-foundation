# IOReader

現在の入力文法とAPIの対応は [INPUT_GRAMMAR.md](INPUT_GRAMMAR.md) を参照。
以下は従来の意図の記録であり、明示的な入力モード追加前の記述を含む。

## 意図の整理

### stdin系

cinの模倣動作。トークン単位動作をする。

文字列の単語扱いは、単数に限定する。
文字列 = 文字列.stdin
- `String.stdin`
- `[Character].stdin`
- `[UInt8].stdin`

単語の配列や単語の二次配列は、stdin系統から除外していく。

以下の二つは特例でそのままで残す。

- 文字列 = 文字列.stdin(columns:)
- 文字列配列 = 文字列配列.stdin(rows:columns:)

stdin系の文字列と二次元配列の組み合わせは文字列配列に限定する。
（文字列の単語単位入力は鉄則本では欲しいが、AtCoderの普段の問題では必要ないため）
単語の二次元配列は削除。

- 文字列.stdin(rows:)
- 文字列配列.stdin(rows:)
