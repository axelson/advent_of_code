defmodule Day3 do
  # @file_path Path.join(__DIR__, "short")
  @file_path Path.join(__DIR__, "input")

  def part1 do
    Advent.input(@file_path)
    |> distance()
  end

  def part2() do
    Advent.input(@file_path)
    |> input_to_board()
    |> total_distance()
  end

  def part2_distance(input) do
    input_to_board(input)
    |> total_distance()
  end

  def input_to_board(input) do
    [wire1_commands, wire2_commands] =
      String.split(input, "\n", trim: true)
      |> Enum.map(&String.split(&1, ","))

    Board.new()
    |> Board.add_wire(:a, wire1_commands)
    |> Board.add_wire(:b, wire2_commands)
  end

  def distance(input) do
    input_to_board(input)
    |> manhattan_distance()
  end

  def manhattan_distance(board) do
    %Board{intersections: intersections} = board

    intersections
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  def total_distance(board) do
    %Board{intersections: intersections} = board

    intersections
    |> Enum.map(fn pos ->
      %{a: wire1_distances, b: wire2_distances} =
        Board.get_distances(board, pos)
        |> Enum.group_by(fn {wire_id, _} -> wire_id end, fn {_, dist} -> dist end)

      Enum.min(wire1_distances) + Enum.min(wire2_distances)
    end)
    |> Enum.min()
  end
end
