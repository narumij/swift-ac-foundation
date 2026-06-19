# IOReader Recipes

English | [日本語](IOReaderRecipes.ja.md)

(For the IOReader concepts, see [IOReader Concepts](IOReaderConcepts.md).)

This page shows practical input patterns using IOReader.

## Reading Strings

For the following input:

```
Apple
```

read it as follows:

```swift
let S = String.stdin // -> "Apple"
```

If multiple words are separated by spaces:

```
Apple Banana
```

read them as follows:

```swift
let S = String.stdin // -> "Apple"
let T = String.stdin // -> "Banana"
```

For a string grid with height and width:

```
4 4
####
#..#
#..#
####
```

read it as follows:

```swift
let H = Int.stdin // -> 4
let W = Int.stdin // -> 4
let S = [String].stdin(rows: H, columns: W)
// -> [
//   "####",
//   "#..#",
//   "#..#",
//   "####"
// ]
```

## Reading Sequences

For an array with a length prefix:

```
4
5 6 7 8
```

read it as follows:

```swift
let N = Int.stdin // -> 4
let A = [Int].stdin(columns: N)
// -> [5, 6, 7, 8]
```

For a 2D array with explicit dimensions:

```
3 3
1 2 3
4 5 6
7 8 9
```

read it as follows:

```swift
let N = Int.stdin // -> 3
let M = Int.stdin // -> 3
let A = [Int].stdin(rows: N, columns: M)
// -> [
//     1, 2, 3,
//     4, 5, 6,
//     7, 8, 9,
//    ]
```

## Tuples

When reading multiple values:

```
4 8
```

You can write:

```swift
let (N, M): (Int, Int) = stdin()
// N -> 4
// M -> 8
```

## Summary

With the `stdin` methods on types and the `stdin()` function,
you can read arrays, 2D arrays, and tuples concisely.

Next page: [IOReader Reference](IOReaderReference.md)
