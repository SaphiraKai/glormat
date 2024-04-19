import gleam/option.{type Option}

pub type Specifier {
  Specifier(precision: Option(Int))
}

pub type Format {
  Format(argument: Option(String), specifier: Specifier)
}
