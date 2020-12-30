defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI

  def fake_created_at_list(values) do
    values
    |> Enum.map(&%{"created_at" => &1, "other_data" => "blabla"})
  end

  test "help works" do
    assert parse_args(["-h", "blaaksdf"]) == :help
    assert parse_args(["--help", "blaaksdf"]) == :help
  end

  test "regular args work" do
    assert parse_args(["user", "test_repo", "99"]) == {"user", "test_repo", 99}
  end

  test "sorts issues desc" do
    fake_issues = fake_created_at_list([3, 1, 2])
    sorted = sort(fake_issues)
    assert Enum.at(sorted, 0)["created_at"] == 3
  end
end
