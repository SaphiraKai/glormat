import gleam/result
import gleam/string
import parse
import eval

// pub fn format(
//   in format_string: String,
//   replace label: String,
//   with data: String,
// ) -> Result(String, Nil) {
//   let to_replace = "{" <> label <> "}"
//   let contains_label =
//     format_string
//     |> string.contains(to_replace)

//   case contains_label {
//     True -> Ok(string.replace(in: format_string, each: to_replace, with: data))
//     False -> Error(parse.MissingTarget)
//   }
// }

/// Replace all instances of `"{label}"` with `data` in the input string.
///
/// To replace more labels, pipe this function into `then` or `then_debug`.
///
/// If you want to use `format` in a pipeline, `replace` may be more concise.
///
/// If the given label isn't found, this function returns `Error(Nil).`
///
/// ## Examples
///
/// ```gleam
/// let assert Ok("hello world") =
///   format(in: "hello {object}", replace: "object", with: "world")
/// ```
pub fn format(
  in format_string: String,
  replace target: String,
  with data: a,
) -> Result(String, parse.Error) {
  eval.format(in: format_string, replace: target, with: data)
}

/// An alias for `format` that may lend more readable code.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok("hello world") =
///   "hello {object}"
///   |> replace("object", with: "world")
/// ```
pub fn replace(
  in format_string: String,
  replace target: String,
  with data: a,
) -> Result(String, parse.Error) {
  format(in: format_string, replace: target, with: data)
}

// pub fn debug(
//   in format_string: String,
//   replace label: String,
//   with data: a,
// ) -> Result(String, parse.Error) {
//   format(in: format_string, replace: label, with: string.inspect(data))
// }

/// A wrapper for `format` that calls `string.inspect` on `data` before passing it in.
///
/// This allows formatting with non-`String` data.
/// If `result` is `Ok`, call `format` on the contained value, otherwise return the `Error`.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok("hello world, how are you?") =
///   "hello {object}, {question}?"
///   |> replace("object", with: "world")
///   |> then("question", with: "how are you")
/// ```
pub fn then(
  in result: Result(String, parse.Error),
  replace target: String,
  with data: String,
) -> Result(String, parse.Error) {
  fn(format_string) { format(in: format_string, replace: target, with: data) }
  |> result.map(result, _)
  |> result.flatten()
}
/// A wrapper for `then` that calls `string.inspect` on `data` before passing it in.
/// This allows formatting with non-String data.
// pub fn then_debug(
//   in result: Result(String, parse.Error),
//   replace label: String,
//   with data: a,
// ) -> Result(String, parse.Error) {
//   then(in: result, replace: label, with: string.inspect(data))
// }
