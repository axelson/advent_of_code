defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  def run do
    {:ok, input} = File.read("day1_input.txt")
    input
    |> String.split("\n")
    |> Enum.map(fn
      "+" <> num_string -> {:add, parse_num(num_string)}
      "-" <> num_string -> {:sub, parse_num(num_string)}
      "" -> :noop
    end)
    |> Enum.reduce(0, fn
      {:add, num}, acc -> acc + num
      {:sub, num}, acc -> acc - num
      :noop, acc -> acc
    end)
  end

  defp parse_num(num_string) do
    {num, ""} = Integer.parse(num_string)
    num
  end
end
