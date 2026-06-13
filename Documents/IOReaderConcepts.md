# IOReader Concepts

English | [日本語](IOReaderConcepts.ja.md)

The IOReader included in AcFoundation provides a way to read input values token by token.

## How It Works

Given the following input:

```
3
1 2 3
```

### Standard Input

If you read it with `readLine()`:

```
_ = readLine() // -> "3"
```

The remaining input is:

```
1 2 3
```

Reading once more gives:

```
_ = readLine() // -> "1 2 3"
```

The remaining input is empty:

```
(EOF)
```

Strings read line by line usually need to be split or converted before use.

### IOReader

If you read the same input with `Int.stdin`:

```
_ = Int.stdin // -> 3
```

The remaining input is:

```
1 2 3
```

Reading again gives:

```
_ = Int.stdin // -> 1
```

The remaining input is:

```
2 3
```

Reading again gives:

```
_ = Int.stdin // -> 2
```

The remaining input is:

```
3
```

Reading again gives:

```
_ = Int.stdin // -> 3
```

The remaining input is empty:

```
(EOF)
```

The value is returned as the specified or inferred type, so no extra conversion is needed.

### Combining IOReader with readLine()

IOReader consumes only the input it needs and does not read ahead.

If IOReader leaves the following input:

```
2 3
```

then using `readLine()` reads that rest of the line:

```
_ = readLine() // -> "2 3"
```

The remaining input is empty:

```
(EOF)
```

This makes it possible to combine IOReader with your own input helpers.

## Tokens

IOReader handles numbers, strings, and characters.

| Category | Types |
|---|---|
| Numbers | `Int`, `UInt`, `Double` |
| Strings | `String`, `[Character]`, `[UInt8]` |
| Characters | `Character`, `UInt8` |

`[Character]` and `[UInt8]` can be used for string input, and `UInt8` can be used for character input.

Although `UInt8` is a numeric type, IOReader treats it as character data.
Use another integer type when you want to read a number.

### Summary

IOReader behaves similarly to C++ `cin`.

The `stdin` property on each supported type reads a value directly as that type.

Next page: [IOReader Recipes](IOReaderRecipes.md)
