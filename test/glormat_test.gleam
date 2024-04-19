import fmt
import gleeunit
import gleeunit/should
import glormat.{assert_ok}

pub fn main() {
  gleeunit.main()
}

pub fn format_test() {
  "1 left {object} right"
  |> fmt.format(replace: "object", with: fmt.with("replaced"))
  |> should.equal(Ok("1 left replaced right"))

  "2 {}! hello {} again"
  |> fmt.format(replace: "", with: fmt.with("world"))
  |> should.equal(Ok("2 world! hello world again"))

  "3 {result}"
  |> fmt.format(replace: "result", with: fmt.with(1 + 2))
  |> should.equal(Ok("3 3"))

  "4 {result:.2}"
  |> fmt.format(replace: "result", with: fmt.with(1.0 /. 3.0))
  |> should.equal(Ok("4 0.33"))

  "5 {result:.0}"
  |> fmt.format(replace: "result", with: fmt.with(3.0 /. 2.0))
  |> should.equal(Ok("5 1.0"))

  "6 {result:.3}"
  |> fmt.format(replace: "result", with: fmt.with(128_000))
  |> should.equal(Ok("6 128"))
}

// pub fn debug_test() {
//   "{}"
//   |> fmt.debug(replace: "", with: True)
//   |> should.equal(Ok("True"))

//   "{}"
//   |> fmt.debug(replace: "", with: 1 + 2)
//   |> should.equal(Ok("3"))
// }

// pub fn then_test() {
//   Ok("{}")
//   |> fmt.then(replace: "", with: "test")
//   |> should.equal(Ok("test"))

//   Error(parse.MissingTarget)
//   |> fmt.then(replace: "", with: "test")
//   |> should.equal(Error(parse.MissingTarget))
// }

// pub fn then_debug_test() {
//   Ok("{}")
//   |> fmt.then_debug(replace: "", with: 1 + 2)
//   |> should.equal(Ok("3"))

//   Error(Nil)
//   |> fmt.then_debug(replace: "", with: 1 + 2)
//   |> should.equal(Error(Nil))
// }

pub fn assert_ok_test() {
  Ok("test")
  |> assert_ok
  |> should.equal("test")
}
