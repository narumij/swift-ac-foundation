# Swift Input For Serious Competitor

## Class Property

```swift
static var stdin: Self { get }
```

標準入力から値を1つ取得して返します。

### Available Types

- Int
- UInt
- Int64
- UInt64

## Class Function

```swift
static func stdin(columns: Int) -> [Self]
```

columnsで指定した個数の配列を標準入力から取得して返します。

### Available Types

- `[Int]`
- `[UInt]`
