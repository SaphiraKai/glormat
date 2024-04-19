import gleam/dynamic.{type Dynamic}
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import parse/data.{type Data}
import parse/error.{type Error}
import parse/format.{type Format, type Specifier, Format, Specifier}

// fn braces(input: String) -> Result(String, Error) {
//   let left_rest = string.split_once(input, "{")
//   let inner_right = result.try(left_rest, fn(a) { string.split_once(a.1, "}") })

//   case inner_right {
//     Ok(#(inner, _)) -> Ok(inner)
//     Error(_) -> Error(InvalidTarget)
//   }
// }

pub fn left_target_right(
  input: String,
  label: String,
) -> Result(#(String, String, String), Error) {
  let split_once = fn(a, b, e) {
    string.split_once(a, b)
    |> result.map_error(fn(_) { e })
  }

  case label {
    "" -> {
      let left_right = split_once(input, "{}", error.MissingTarget)
      use #(left, right) <- result.map(left_right)

      #(left, "", right)
    }
    _ -> {
      let left_rest = split_once(input, "{" <> label, error.MissingTarget)
      use #(left, rest) <- result.then(left_rest)

      let specifier_right = split_once(rest, "}", error.InvalidTarget)
      use #(specifier, right) <- result.map(specifier_right)

      #(left, label <> specifier, right)
    }
  }
}

fn precision(input: String) -> Result(Int, Error) {
  let left_precision = string.split_once(input, ".")

  case left_precision {
    Ok(#(_, precision)) ->
      int.parse(precision)
      |> result.map_error(fn(_) { error.InvalidPrecision })
    Error(_) -> Error(error.MissingPrecision)
  }
}

// fn kind(input: String) -> Result(Kind, Error) {
//   let left_kind = string.split_once(input, "+")

//   case left_kind {
//     Ok(#(_, "s")) -> Ok(String)
//     Ok(#(_, "i")) -> Ok(Int)
//     Ok(#(_, "f")) -> Ok(Float)
//     Ok(#(_, _)) -> Error(InvalidKind)
//     _ -> Error(MissingKind)
//   }
// }

fn specifier(input: String) -> Result(Specifier, Error) {
  let spec = Specifier(None)

  // let spec_kind = case kind(input) {
  //   Ok(kind) -> Ok(Specifier(..spec, kind: kind))
  //   Error(MissingKind) -> Ok(Specifier(..spec, kind: String))
  //   Error(e) -> Error(e)
  // }
  // use spec <- result.then(spec_kind)

  let spec_precision = case precision(input) {
    Ok(precision) -> Ok(Specifier(..spec, precision: Some(precision)))
    Error(error.MissingPrecision) -> Ok(Specifier(..spec, precision: None))
    Error(e) -> Error(e)
  }
  use spec <- result.map(spec_precision)

  spec
}

pub fn format(input: String) -> Result(Format, Error) {
  let #(label, spec_string) =
    input
    |> string.split_once(":")
    |> result.unwrap(#(input, ""))

  use specifier <- result.map(specifier(spec_string))

  Format(string.to_option(label), specifier)
}
