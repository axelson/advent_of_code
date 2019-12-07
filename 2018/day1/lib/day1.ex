defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  def run do
    input()
    |> String.split("\n")
    |> operations()
    |> Enum.reduce(0, fn
      :noop, acc -> acc
      input, cur_freq -> new_freq(input, cur_freq)
    end)
  end

  def part2 do
    input()
    |> String.split("\n")
    |> operations()
    |> Stream.cycle()
    |> Enum.reduce_while({0, %{}}, fn
      :noop, cur_freq ->
        {:cont, cur_freq}

      {op, num}, {cur_freq, prev_freqs} ->
        new_freq = new_freq({op, num}, cur_freq)

        if Map.get(prev_freqs, new_freq) do
          {:halt, new_freq}
        else
          {:cont, {new_freq, Map.put(prev_freqs, new_freq, true)}}
        end
    end)
  end

  defp new_freq({:add, num}, cur_freq), do: cur_freq + num
  defp new_freq({:sub, num}, cur_freq), do: cur_freq - num

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
