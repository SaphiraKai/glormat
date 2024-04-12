import gleeunit
import gleeunit/should

import fmt
import glormat.{assert_ok}

pub fn main() {
  gleeunit.main()
}

pub fn format_test() {
  "hello {object}"
  |> fmt.format(replace: "object", with: "world")
  |> should.equal(Ok("hello world"))

  "hello {object}! hello {object} again"
  |> fmt.format(replace: "object", with: "world")
  |> should.equal(Ok("hello world! hello world again"))

  "hello {}"
  |> fmt.format(replace: "", with: "world")
  |> should.equal(Ok("hello world"))

  "hello {}"
  |> fmt.format(replace: "", with: "")
  |> should.equal(Ok("hello "))
}

pub fn debug_test() {
  "{}"
  |> fmt.debug(replace: "", with: True)
  |> should.equal(Ok("True"))

  "{}"
  |> fmt.debug(replace: "", with: 1 + 2)
  |> should.equal(Ok("3"))
}

pub fn then_test() {
  Ok("{}")
  |> fmt.then(replace: "", with: "test")
  |> should.equal(Ok("test"))

  Error(Nil)
  |> fmt.then(replace: "", with: "test")
  |> should.equal(Error(Nil))
}

pub fn then_debug_test() {
  Ok("{}")
  |> fmt.then_debug(replace: "", with: 1 + 2)
  |> should.equal(Ok("3"))

  Error(Nil)
  |> fmt.then_debug(replace: "", with: 1 + 2)
  |> should.equal(Error(Nil))
}

pub fn assert_ok_test() {
  Ok("test")
  |> assert_ok
  |> should.equal("test")
}
