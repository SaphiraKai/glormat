import gleam/float
import gleam/int
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import parse
import parse/data.{type Data}
import parse/error.{type Error}
import parse/format.{type Format}

fn truncate_string(data: String, up_to precision: Int) -> String {
  let count = string.length(data) - precision

  string.drop_right(data, count)
}

fn truncate_int(data: Int, up_to precision: Int) -> String {
  truncate_string(string.inspect(data), precision)
}

fn truncate_float(data: Float, up_to precision: Int) -> String {
  // this `assert` is safe because the base is always 10,
  // therefore neither error case in `float.power` is possible
  let assert Ok(multiplier) = float.power(10.0, of: int.to_float(precision))

  // yup, this is how i'm doing this
  // feels kinda cursed but oh well
  {
    data *. multiplier
    |> float.truncate()
    |> int.to_float
  }
  /. multiplier
  |> string.inspect
}

fn expand_string(data: String, format: Format) -> String {
  case format.specifier.precision {
    Some(precision) -> truncate_string(data, precision)
    None -> data
  }
}

fn expand_int(data: Int, format: Format) -> String {
  case format.specifier.precision {
    Some(precision) -> truncate_int(data, precision)
    None -> string.inspect(data)
  }
}

fn expand_float(data: Float, format: Format) -> String {
  case format.specifier.precision {
    Some(precision) -> truncate_float(data, precision)
    None -> string.inspect(data)
  }
}

fn expand(data: Data, format: Format) -> String {
  case data {
    data.StringData(data) -> expand_string(data, format)
    data.IntData(data) -> expand_int(data, format)
    data.FloatData(data) -> expand_float(data, format)
  }
}

pub fn format_one(
  in format_string: String,
  replace label: String,
  with data: Data,
) -> Result(String, Error) {
  use #(left, target, right) <- result.then(parse.left_target_right(
    format_string,
    label,
  ))

  use format <- result.map(parse.format(target))

  let expanded = expand(data, format)

  left <> expanded <> right
}

pub fn format(
  in format_string: String,
  replace label: String,
  with data: Data,
) -> Result(String, Error) {
  do_format(in: format_string, replace: label, with: data, at: 0)
}

fn do_format(
  in format_string: String,
  replace label: String,
  with data: Data,
  at depth: Int,
) -> Result(String, Error) {
  format_one(format_string, label, data)
  |> result.then(do_format(_, label, data, depth + 1))
  |> result.try_recover(fn(a) {
    case a {
      error.MissingTarget if depth > 0 -> Ok(format_string)
      _ -> Error(a)
    }
  })
}
