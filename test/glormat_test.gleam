import gleeunit
import gleeunit/should
import glormat

pub fn main() {
  gleeunit.main()
}

pub fn format_test() {
  "hello {object}"
  |> glormat.format(replace: "object", with: "world")
  |> should.equal(Ok("hello world"))

  "hello {object}! hello {object} again"
  |> glormat.format(replace: "object", with: "world")
  |> should.equal(Ok("hello world! hello world again"))

  "hello {}"
  |> glormat.format(replace: "", with: "world")
  |> should.equal(Ok("hello world"))

  "hello {}"
  |> glormat.format(replace: "", with: "")
  |> should.equal(Ok("hello "))
}

pub fn debug_test() {
  "{}"
  |> glormat.debug(replace: "", with: True)
  |> should.equal(Ok("True"))

  "{}"
  |> glormat.debug(replace: "", with: 1 + 2)
  |> should.equal(Ok("3"))
}

pub fn then_test() {
  Ok("{}")
  |> glormat.then(replace: "", with: "test")
  |> should.equal(Ok("test"))

  Error(Nil)
  |> glormat.then(replace: "", with: "test")
  |> should.equal(Error(Nil))
}

pub fn then_debug_test() {
  Ok("{}")
  |> glormat.then_debug(replace: "", with: 1 + 2)
  |> should.equal(Ok("3"))

  Error(Nil)
  |> glormat.then_debug(replace: "", with: 1 + 2)
  |> should.equal(Error(Nil))
}
