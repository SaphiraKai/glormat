import gleam/io
import gleam/option
import gleam/result
import gleam/string
import parse

fn truncate(data: String, up_to precision: Int) -> String {
  let count = string.length(data) - precision

  string.drop_right(data, count)
}

fn expand(data: String, format: parse.Format) -> String {
  format.specifier.precision
  |> option.map(truncate(data, _))
  |> option.unwrap(data)
}

pub fn format_one(
  in format_string: String,
  replace label: String,
  with data: a,
) -> Result(String, parse.Error) {
  // let left_target_right =
  //   case label {
  //     "" -> {
  //       use #(left, right) <- result.map(string.split_once(format_string, "{}"))

  //       #(left, "", right)
  //     }
  //     _ -> {
  //       let left_rest = string.split_once(format_string, "{" <> label)
  //       use #(left, rest) <- result.then(left_rest)
  //       use #(inner, right) <- result.map(string.split_once(rest, "}"))

  //       #(left, label <> inner, right)
  //     }
  //   }
  //   |> result.map_error(fn(_) { parse.InvalidTarget })
  //   |> io.debug

  use #(left, target, right) <- result.then(parse.left_target_right(
    format_string,
    label,
  ))
  use format <- result.map(parse.format(target))

  let expanded = expand(string.inspect(data), format)

  left <> expanded <> right
  // let left_rest = string.split_once(format_string, target)
  // let inner_right = result.try(left_rest, fn(a) { string.split_once(a.1, "}") })

  // let data_string = string.inspect(data)

  // use left <- result.try(left_rest)
  // use #(inner, right) <- result.try(inner_right)

  // let format = case inner_right {
  //   Ok(#(inner, _)) -> parse.format(inner)
  //   Error(_) -> Error(parse.MissingTarget)
  // }

  // use expanded <- result.try(
  //   result.map(format, fn(a) { expand(data_string, a) }),
  // )

  // case left_rest, inner_right {
  //   Ok(#(left, _)), Ok(#(_, right)) -> Ok(left <> expanded <> right)
  //   Ok(_), Error(_) -> Error(parse.InvalidTarget)
  //   Error(_), _ -> Error(parse.MissingTarget)
  // }
}

pub fn format(
  in format_string: String,
  replace label: String,
  with data: a,
) -> Result(String, parse.Error) {
  do_format(in: format_string, replace: label, with: data, at: 0)
}

fn do_format(
  in format_string: String,
  replace label: String,
  with data: a,
  at depth: Int,
) -> Result(String, parse.Error) {
  format_one(format_string, label, data)
  |> result.then(do_format(_, label, data, depth + 1))
  |> result.try_recover(fn(a) {
    case a {
      parse.MissingTarget if depth > 1 -> Ok(format_string)
      _ -> Error(a)
    }
  })
}
