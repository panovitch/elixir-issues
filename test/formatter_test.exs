defmodule FormatterTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Formatter

  @test_data [
    %{"a" => 23, "b" => "blaaa", "c" => "gggggg"},
    %{"a" => 232, "b" => "bla", "c" => "gggggg"},
    %{"a" => 23, "b" => "a", "c" => "gggggg"}
  ]

  @test_printable_data [
    %{"a" => "23", "b" => "blaaa", "cc" => "g"},
    %{"a" => "232", "b" => "bla", "cc" => "g"},
    %{"a" => "23", "b" => "a", "cc" => "g"}
  ]

  test "printable converts to str" do
    record = %{"a" => 23, "b" => "test", "c" => "bla"}
    res = printable(record, ["a", "b"])
    assert res == %{"a" => "23", "b" => "test"}
  end

  test "field_width_works" do
    assert get_field_width(@test_printable_data, "a") == 3
    assert get_field_width(@test_printable_data, "b") == 5
    assert get_field_width(@test_printable_data, "cc") == 2
  end

  test "get header" do
    assert get_header([{"a", 3}, {"bb", 4}]) == "a   | bb  "
  end
end
