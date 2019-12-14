defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  def input(filename) do
    {:ok, input} = File.read(filename)
    input
  end

  def linewise_input(filename) do
    input(filename)
    |> String.split("\n", trim: true)
  end

  def comma_input(filename) do
    input(filename)
    |> String.trim()
    |> String.split(",")
  end

  def print_black(text), do: IO.ANSI.black_background() <> text <> IO.ANSI.reset()

  def print_grid(grid, fun) when is_function(fun, 1) do
    coords = Map.keys(grid)
    {{max_x, _}, {min_x, _}} = Enum.min_max_by(coords, fn {x, _y} -> x end)
    {{_, max_y}, {_, min_y}} = Enum.min_max_by(coords, fn {_x, y} -> y end)

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        fun.(Map.get(grid, {x, y}))
      end
    end
    |> Enum.reverse()
    |> Enum.join("\n")
    |> IO.puts()
  end
end
