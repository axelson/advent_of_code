defmodule Day6.Coords do
  # Write a function that takes a point and returns all the points of manhattan
  # distance `d` from it
  def coords(point, distance)

  def coords({x, y}, 0), do: [{x, y}]
  def coords({x, y}, d) do
    [
      {0..d, -d..0},
      {d..0, 0..d},
      {0..-d, d..0},
      {-d..0, 0..-d}
    ]
    |> Enum.flat_map(fn {x_range, y_range} ->
      Enum.zip(x_range, y_range)
    end)
    |> Enum.uniq()
    |> Enum.map(fn {coord_x, coord_y} -> {x + coord_x, y + coord_y} end)
  end
end
