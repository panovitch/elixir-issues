defmodule Issues.CLI do\
    @default_count 4
    @moduledoc """
    blabla
    """
    @spec run([binary]) :: :help | {any, any, integer}
    def run(argv) do
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
    def args_to_internal_representation( _ ) do
      :help
    end

    def process(:help) do
      IO.puts """
      heyyy this is help
      """
      System.halt(0)
    end
    def process({user, project, _count}) do
      Issues.GithubIssues.fetch(user, project)
      |> decode_response()
    end

    def decode_response({:ok, body}), do: body
    def decode_response({:error, error}) do
      IO.puts("Booom! #{error}")
      System.halt(2)
    end

end
