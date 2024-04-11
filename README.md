# glormat

A simple, readable string formatting library for Gleam!

[![Package Version](https://img.shields.io/hexpm/v/glormat)](https://hex.pm/packages/glormat)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glormat/)

```sh
gleam add glormat
```
```gleam
import gleam/io
import glormat.{assert_ok, replace, then, then_debug}

pub fn main() {
  "hello {object}, the {operation} is {result}"
    |> replace("object", with: "world")
    |> then("operation", with: "sum")
    |> then_debug("result", with: 1 + 2)
    |> assert_ok
    |> io.println // hello world, the sum is 3
}
```

Further documentation can be found at <https://hexdocs.pm/glormat>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
