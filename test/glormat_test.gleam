import gleeunit
import gleeunit/should
import fmt
import glormat.{assert_ok}
import parse

pub fn main() {
  gleeunit.main()
}

pub fn format_test() {
  "1 left {object:} right"
  |> fmt.format(replace: "object", with: "replaced")
  |> should.equal(Ok("1 left replaced right"))
  // "2 {object}! hello {object} again"
  // |> fmt.format(replace: "object", with: "world")
  // |> should.equal(Ok("hello world! hello world again"))

  // "3 {}"
  // |> fmt.format(replace: "", with: "world")
  // |> should.equal(Ok("hello world"))

  // "4 {}"
  // |> fmt.format(replace: "", with: "")
  // |> should.equal(Ok("hello "))
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
