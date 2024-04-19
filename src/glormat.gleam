import fmt
import gleam/io

/// Assert that `result` is `Ok`, returning the contained `String`. This may be useful in cases where you as the programmer know that formatting will not fail, but the compiler does not.
pub fn assert_ok(result: Result(a, e)) -> a {
  let assert Ok(value) = result

  value
}

pub fn main() {
  "a {blank} string, with more {blank}"
  |> fmt.replace("blank", fmt.with("test"))
  |> assert_ok
  |> io.println

  "{left} {op} {right} = {result:.2}"
  |> fmt.replace("left", fmt.with(1.0))
  |> fmt.then("op", fmt.with("/."))
  |> fmt.then("right", fmt.with(3.0))
  |> fmt.then("result", fmt.with(1.0 /. 3.0))
  |> assert_ok
  |> io.println
}
