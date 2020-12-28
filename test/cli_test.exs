defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [ parse_args: 1 ]

  test "help works" do
    assert parse_args(["-h", "blaaksdf"]) == :help
    assert parse_args(["--help", "blaaksdf"]) == :help
  end
  test "regular args work" do
    assert parse_args(["user", "test_repo", "99"]) == { "user", "test_repo", 99 }
  end
end
