import gleam/dynamic.{type Dynamic}
import gleam/result
import parse/error.{type Error}

pub type DataType {
  StringType
  IntType
  FloatType
}

pub type Data {
  StringData(String)
  IntData(Int)
  FloatData(Float)
}

pub fn from(this data: Dynamic, is data_type: DataType) -> Result(Data, Error) {
  case data_type {
    StringType ->
      dynamic.string(data)
      |> result.map(StringData)
      |> result.nil_error

    IntType ->
      dynamic.int(data)
      |> result.map(IntData)
      |> result.nil_error

    FloatType ->
      dynamic.float(data)
      |> result.map(FloatData)
      |> result.nil_error
  }
  |> result.map_error(fn(_) { error.InvalidDataType })
}
