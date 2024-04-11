import gleeunit
import gleeunit/should
import glormat.{assert_ok, debug, format, then, then_debug}

pub fn main() {
  gleeunit.main()
}

pub fn format_test() {
  "hello {object}"
  |> format(replace: "object", with: "world")
  |> should.equal(Ok("hello world"))

  "hello {object}! hello {object} again"
  |> format(replace: "object", with: "world")
  |> should.equal(Ok("hello world! hello world again"))

  "hello {}"
  |> format(replace: "", with: "world")
  |> should.equal(Ok("hello world"))

  "hello {}"
  |> format(replace: "", with: "")
  |> should.equal(Ok("hello "))
}

pub fn debug_test() {
  "{}"
  |> debug(replace: "", with: True)
  |> should.equal(Ok("True"))

  "{}"
  |> debug(replace: "", with: 1 + 2)
  |> should.equal(Ok("3"))
}

pub fn then_test() {
  Ok("{}")
  |> then(replace: "", with: "test")
  |> should.equal(Ok("test"))

  Error(Nil)
  |> then(replace: "", with: "test")
  |> should.equal(Error(Nil))
}

pub fn then_debug_test() {
  Ok("{}")
  |> then_debug(replace: "", with: 1 + 2)
  |> should.equal(Ok("3"))

  Error(Nil)
  |> then_debug(replace: "", with: 1 + 2)
  |> should.equal(Error(Nil))
}

pub fn assert_ok_test() {
  Ok("test")
  |> assert_ok
  |> should.equal("test")
}
