/// Assert that `result` is `Ok`, returning the contained `String`. This may be useful in cases where you as the programmer know that formatting will not fail, but the compiler does not.
pub fn assert_ok(result: Result(String, Nil)) -> String {
  let assert Ok(string) = result

  string
}
