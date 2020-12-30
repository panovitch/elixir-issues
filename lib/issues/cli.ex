defmodule Issues.CLI do
  @default_count 4
  @id_header_width 10
  @date_header_width 30
  @title_header_width 40

  @moduledoc """
  blabla
  """
  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @spec parse_args([binary]) :: :help | {any, any, integer}
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  @spec args_to_internal_representation(any) :: :help | {any, any, integer}
  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    heyyy this is help
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort()
    |> last_n(count)
    |> Issues.Formatter.format(["number", "created_at", "title"])
  end

  @spec decode_response({:ok, any}) :: any
  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Booom! #{error}")
    System.halt(2)
  end

  def sort(issues) do
    issues
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end

  def last_n(issues, count) do
    issues
    |> Enum.take(count)
  end

  def format(issues) do
    print_header()

    issues
    |> Enum.each(&print_issue(&1))
  end

  def print_issue(issue) do
    number = " " <> Integer.to_string(issue["number"])
    created = " " <> issue["created_at"]
    title = " " <> issue["title"]

    IO.puts(
      String.pad_trailing(number, @id_header_width) <>
        "|" <>
        String.pad_trailing(created, @date_header_width) <>
        "|" <> String.pad_trailing(title, @title_header_width)
    )
  end

  def print_header do
    IO.puts(
      String.pad_trailing(" #", @id_header_width) <>
        "|" <>
        String.pad_trailing(" created_at", @date_header_width) <>
        "|" <> String.pad_trailing(" title", @title_header_width)
    )

    IO.puts(
      String.duplicate("-", @id_header_width) <>
        "+" <>
        String.duplicate("-", @date_header_width) <>
        "+" <> String.duplicate("-", @title_header_width)
    )
  end
end
