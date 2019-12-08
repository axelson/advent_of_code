defmodule Day3 do
  # @file_path Path.join(__DIR__, "short")
  @file_path Path.join(__DIR__, "input")

  def part1 do
    Advent.input(@file_path)
    |> distance()
  end

  def distance(input) do
    [wire1_commands, wire2_commands] =
      String.split(input, "\n", trim: true)
      |> Enum.map(&String.split(&1, ","))

    board =
      Board.new()
      |> Board.add_wire(:a, wire1_commands)
      |> Board.add_wire(:b, wire2_commands)

    manhattan_distance(board)
  end

  def manhattan_distance(board) do
    %Board{intersections: intersections} = board

    intersections
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end
end
