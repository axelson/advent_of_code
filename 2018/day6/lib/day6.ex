defmodule Day6 do
  alias Day6.Coords

  def part1 do
    # Advent.linewise_input("short.txt")
    Advent.linewise_input("day6_input.txt")
    |> coords()
    |> flood_fill()
  end

  def coords(input) do
    input
    |> Enum.map(&String.split(&1, ", "))
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
  end

  def flood_fill(coords) do
    {max_x, _} = Enum.max_by(coords, &x_coord/1)
    {_, max_y} = Enum.max_by(coords, &y_coord/1)

    coords_with_name =
      coords
      |> Enum.with_index()
      |> Enum.map(fn {coord, index} ->
        {coord, ?A + index}
      end)

    {_, last_char} = List.last(coords_with_name)

    coords_map =
      coords_with_name
      |> Enum.reduce(%{}, fn {{x, y}, char}, coords_map ->
        Map.put(coords_map, {x, y}, {char, 0})
      end)

    # draw(coords_map, max_x, max_y)

    # We also need to keep a mapset of coords that have been filled
    # once all coords have been filled then we are done

    coords_map =
      coords_with_name
      |> Stream.cycle()
      |> Enum.reduce_while({coords_map, 0, MapSet.new()}, fn {point, char},
                                                             {coords_map, dist, seen_coords} ->
        coords_map =
          Coords.coords(point, dist)
          |> mark_coords(coords_map, lowercase(char), dist, max_x, max_y)

        # TODO: Record changes instead of this
        if dist > max_x && dist > max_y do
          {:halt, coords_map}
        else
          if char == last_char do
            {:cont, {coords_map, dist + 1, seen_coords}}
          else
            {:cont, {coords_map, dist, seen_coords}}
          end
        end

        # Fill in each coord of dist with this char (lowercase)
        # Map.get_update(coords_map, fn val ->
        # end)
      end)

    # draw(coords_map, max_x, max_y)

    letters_with_infinite_area = infinite_area(coords_map, max_x, max_y)

    potential_letters =
      coords_with_name
      |> Enum.map(fn {_coord, char} -> char end)
      |> MapSet.new()
      |> MapSet.difference(letters_with_infinite_area)

    count_by_char =
    coords_map
    |> Enum.group_by(fn {_coord, {char, _dist}} -> uppercase(char) end)
    |> Enum.map(fn {char, vals} -> {char, length(vals)} end)
    |> Enum.into(%{})

    {_char, count} =
    potential_letters
    |> Enum.map(fn char ->
      {(char), Map.get(count_by_char, char)}
    end)
    |> Enum.max_by(fn {_char, count} -> count end)

    count + 1
  end

  defp infinite_area(coords_map, max_x, max_y) do
    {width, height} = {max_x, max_y}

    [
      {0..max_x, List.duplicate(0, width)},
      {List.duplicate(0, height), 0..max_y},
      {max_x..0, List.duplicate(max_y, width)},
      {List.duplicate(0, height), max_y..0}
    ]
    |> Enum.flat_map(fn {x_range, y_range} ->
      Enum.zip(x_range, y_range)
    end)
    |> Enum.reduce(MapSet.new(), fn {x, y}, infinite_area_letters ->
      {char, _} = Map.get(coords_map, {x, y})
      MapSet.put(infinite_area_letters, uppercase(char))
    end)
  end

  defp mark_coords(coords, coords_map, char, dist, max_x, max_y) do
    coords
    |> Enum.reduce(coords_map, fn {x, y}, coords_map ->
      if x <= max_x && y <= max_y && x >= 0 && y >= 0 do
        Map.update(coords_map, {x, y}, {char, dist}, fn
          {_, ^dist} -> {?., dist}
          existing -> existing
        end)
      else
        coords_map
      end
    end)
  end

  def draw(coords_map, max_x, max_y) do
    for y <- 0..max_y do
      0..max_x
      |> Enum.map(fn x ->
        case Map.get(coords_map, {x, y}) do
          nil -> "."
          {char, _dist} -> [char] |> IO.iodata_to_binary()
          char -> [char] |> IO.iodata_to_binary()
        end
      end)
      |> Enum.join()
      |> IO.puts()
    end
  end

  defp x_coord({x, _y}), do: x
  defp y_coord({_x, y}), do: y
  defp lowercase(char), do: char + 32
  defp uppercase(char), do: char - 32
end
