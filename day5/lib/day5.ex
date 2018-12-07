defmodule Day5 do
  @case_difference ?a - ?A

  def part1 do
    # file = "short.txt"
    file = "day5_input.txt"

    input(file)
    |> reduce()
    |> String.length()
  end

  def reduce(input) do
    input
    |> :erlang.binary_to_list()
    |> do_reduce()
    |> IO.iodata_to_binary()
  end

  defp do_reduce(input) do
    case reduce_input(input) do
      ^input -> input
      reduced -> do_reduce(reduced)
    end
  end

  defp reduce_input([]), do: []
  defp reduce_input([char]), do: [char]
  defp reduce_input([char1, char2 | rest]) do
    if opposite_polarities?(char1, char2) do
      reduce_input(rest)
    else
      [char1 | reduce_input([char2 | rest])]
    end
  end

  def input(file) do
    {:ok, input} = File.read(file)
    String.trim(input)
  end

  # Two characters are opposite polarities if they are the same letter but one
  # is uppercase and one is lower case
  defp opposite_polarities?(char1, char2) do
    abs(char1 - char2) == @case_difference
  end
end
