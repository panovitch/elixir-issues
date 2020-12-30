defmodule Issues.Formatter do
  def format(data, fields) do
    printable_data = data |> Enum.map(&printable(&1, fields))
    fields_with_width = get_fields_with_width(printable_data, fields)

    IO.puts(get_header(fields_with_width))

    printable_data
    |> Enum.each(&IO.puts(get_entry(&1, fields_with_width)))
  end

  @spec printable(any, any) :: any
  def printable(entry, fields) do
    fields
    |> Enum.reduce(%{}, &Map.put(&2, &1, to_string(entry[&1])))
  end

  @spec get_fields_with_width(any, binary) :: any
  def get_fields_with_width(data, fields) do
    fields
    |> Enum.map(&{&1, get_field_width(data, &1)})
  end

  def get_field_width(data, field) do
    max_data_length = data |> Enum.map(&String.length(&1[field])) |> Enum.max()
    max(max_data_length, String.length(field))
  end

  def get_header(fields) do
    fields
    |> Enum.map_join(" | ", fn {field, size} -> pad_item(field, size) end)
  end

  @spec pad_item(binary, non_neg_integer) :: binary
  def pad_item(item, max_width) do
    String.pad_trailing(item, max_width)
  end

  def get_entry(entry, fields) do
    fields
    |> Enum.map_join(" | ", fn {field, size} -> pad_item(entry[field], size) end)
  end
end
