import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/io

pub type Kind {
  String
  Int
  Float
}

pub type Specifier {
  Specifier(kind: Kind, precision: Option(Int))
}

pub type Format {
  Format(argument: Option(String), specifier: Specifier)
}

pub type Error {
  InvalidKind
  InvalidPrecision
  InvalidTarget
  MissingFormatSpecifier
  MissingKind
  MissingPrecision
  MissingTarget
}

fn braces(input: String) -> Result(String, Error) {
  let left_rest = string.split_once(input, "{")
  let inner_right = result.try(left_rest, fn(a) { string.split_once(a.1, "}") })

  case inner_right {
    Ok(#(inner, _)) -> Ok(inner)
    Error(_) -> Error(InvalidTarget)
  }
}

pub fn left_target_right(
  input: String,
  label: String,
) -> Result(#(String, String, String), Error) {
  case label {
    "" -> {
      use #(left, right) <- result.map(string.split_once(input, "{}"))

      #(left, "", right)
    }
    _ -> {
      let left_rest = string.split_once(input, "{" <> label)
      use #(left, rest) <- result.then(left_rest)
      use #(inner, right) <- result.map(string.split_once(rest, "}"))

      #(left, label <> inner, right)
    }
  }
  |> result.map_error(fn(_) { InvalidTarget })
}

fn precision(input: String) -> Result(Int, Error) {
  let left_precision = string.split_once(input, ".")

  case left_precision {
    Ok(#(_, precision)) ->
      int.parse(precision)
      |> result.map_error(fn(_) { InvalidPrecision })
    Error(_) -> Error(MissingPrecision)
  }
}

fn kind(input: String) -> Result(Kind, Error) {
  let left_kind = string.split_once(input, "+")

  case left_kind {
    Ok(#(_, "s")) -> Ok(String)
    Ok(#(_, "i")) -> Ok(Int)
    Ok(#(_, "f")) -> Ok(Float)
    Ok(#(_, _)) -> Error(InvalidKind)
    _ -> Error(MissingKind)
  }
}

fn specifier(input: String) -> Result(Specifier, Error) {
  let spec = Specifier(String, None)

  let spec_kind = case kind(input) {
    Ok(kind) -> Ok(Specifier(..spec, kind: kind))
    Error(e) -> Error(e)
  }

  let spec_precision = case precision(input) {
    Ok(precision) -> Ok(Specifier(..spec, precision: Some(precision)))
    Error(MissingPrecision) -> Ok(Specifier(..spec, precision: None))
    Error(e) -> Error(e)
  }

  spec_precision
}

pub fn format(input: String) -> Result(Format, Error) {
  let arg_spec =
    input
    |> string.split_once(":")
    |> result.map_error(fn(_) { MissingFormatSpecifier })

  let arg_specifier = case arg_spec {
    Ok(#(arg, spec)) -> Ok(#(arg, specifier(spec)))
    Error(e) -> Error(e)
  }

  case arg_specifier {
    Ok(#(arg, Ok(spec))) -> Ok(Format(string.to_option(arg), spec))
    Ok(#(_, Error(e))) -> Error(e)
    Error(e) -> Error(e)
  }
}
