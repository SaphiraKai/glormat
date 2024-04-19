import eval
import gleam/dynamic
import gleam/result
import parse/data.{type Data}
import parse/error.{type Error}

pub fn with(from data: a) -> Result(Data, Error) {
  let from = data.from(dynamic.from(data), _)

  from(data.StringType)
  |> result.lazy_or(fn() { from(data.IntType) })
  |> result.lazy_or(fn() { from(data.FloatType) })
}

pub fn with_string(from data: String) -> Result(Data, Error) {
  Ok(data.StringData(data))
}

pub fn with_int(from data: Int) -> Result(Data, Error) {
  Ok(data.IntData(data))
}

pub fn with_float(from data: Float) -> Result(Data, Error) {
  Ok(data.FloatData(data))
}

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
  with data: Result(Data, Error),
) -> Result(String, Error) {
  use data_ok <- result.try(data)

  eval.format(in: format_string, replace: target, with: data_ok)
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
  with data: Result(Data, Error),
) -> Result(String, Error) {
  format(in: format_string, replace: target, with: data)
}

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
  in format_string: Result(String, Error),
  replace target: String,
  with data: Result(Data, Error),
) -> Result(String, Error) {
  use format_string_ok <- result.try(format_string)

  format(in: format_string_ok, replace: target, with: data)
}
/// A wrapper for `then` that calls `string.inspect` on `data` before passing it in.
/// This allows formatting with non-String data.
// pub fn then_debug(
//   in result: Result(String, Error),
//   replace label: String,
//   with data: a,
// ) -> Result(String, Error) {
//   then(in: result, replace: label, with: string.inspect(data))
// }
