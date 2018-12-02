defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  def run do
    input()
    |> String.split("\n")
    |> operations()
    |> Enum.reduce(0, fn
      {:add, num}, acc -> acc + num
      {:sub, num}, acc -> acc - num
      :noop, acc -> acc
    end)
  end

  def part2 do
    input()
    |> String.split("\n")
    |> operations()
    |> Stream.cycle()
    |> Enum.reduce_while({0, %{}}, fn
      {op, num}, {cur_freq, prev_freqs} ->
        new_freq =
          case op do
            :add -> cur_freq + num
            :sub -> cur_freq - num
          end

        if Map.get(prev_freqs, new_freq) do
          {:halt, new_freq}
        else
          {:cont, {new_freq, Map.put(prev_freqs, new_freq, true)}}
        end

      :noop, acc ->
        {:cont, acc}
    end)
  end

  defp operations(input) do
    input
    |> Enum.map(fn
      "+" <> num_string -> {:add, parse_num(num_string)}
      "-" <> num_string -> {:sub, parse_num(num_string)}
      "" -> :noop
    end)
  end

  defp input do
    {:ok, input} = File.read("day1_input.txt")
    input
  end

  defp parse_num(num_string) do
    {num, ""} = Integer.parse(num_string)
    num
  end
end
