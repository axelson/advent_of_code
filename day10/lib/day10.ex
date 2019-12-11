defmodule Day10 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    {_pos, num} =
      Advent.input(@file_path)
      |> best()

    num
  end

  def part2({x, y} \\ {14, 17}) do
    p2(Advent.input(@file_path), {x, y})
  end

  def p2(input, {x, y}) do
    {map, width, height} = parse_input(input)

    p3(map, width, height, {x, y})
  end

  def p3(map, width, height, {x, y}) do
    angles = asteroid_angles(map, width, height, {x, y})

    new_map =
      angles
      |> Enum.reduce(map, fn {{dx, dy}, _}, map ->
        # Boom!
        Map.put(map, {x + dx, y + dy}, :empty)
      end)

    if angles == [] do
      angles
    else
      Enum.concat(angles, p3(new_map, width, height, {x, y}))
    end
  end

  def best(input) do
    counts = asteroid_counts(input)

    Enum.max_by(counts, fn {_, count} -> count end)
  end

  def asteroid_counts(input) do
    map = build_map(input)
    lines = String.split(input, "\n", trim: true)
    width = String.length(hd(lines))
    height = length(lines)

    {x_range, y_range} = {0..(width - 1), 0..(height - 1)}

    for x <- x_range, y <- y_range, Map.get(map, {x, y}) == :asteroid, into: %{} do
      length =
        gen_angles({x, y}, width, height)
        |> Enum.flat_map(&check_angle({x, y}, &1, map, width, height))
        |> length()

      {{x, y}, length}
    end
  end

  def parse_input(input) do
    map = build_map(input)
    lines = String.split(input, "\n", trim: true)
    width = String.length(hd(lines))
    height = length(lines)
    {map, width, height}
  end

  def asteroid_angles(map, width, height, {x, y}) do
    gen_angles({x, y}, width, height)
    |> Enum.flat_map(&check_angle({x, y}, &1, map, width, height))
    |> Enum.map(fn {a_x, a_y} ->
      {dx, dy} = {a_x - x, a_y - y}

      radians =
        :math.atan2(-dy, dx)
        |> sortable_radians()

      {{dx, dy}, radians}
    end)
    |> Enum.sort_by(fn {{_dx, _dy}, radians} -> radians end)
    |> Enum.reverse()
  end

  @pi_div2 :math.pi() / 2
  # Sort based on unit circle starting at top and rotating clockwise
  def sortable_radians(radians) when radians > @pi_div2 do
    radians - 2 * :math.pi()
  end

  def sortable_radians(radians), do: radians

  def check_angle({x, y}, {dx, dy}, map, width, height)
      when x < width and x >= 0 and y < width and y >= 0 do
    pos1 = {x + dx, y + dy}

    if Map.get(map, pos1) == :asteroid do
      [pos1]
    else
      check_angle(pos1, {dx, dy}, map, width, height)
    end
  end

  def check_angle(_, _, _, _, _), do: []

  def gen_angles({pos_x, pos_y}, width, height) do
    for x <- 0..(width - 1), y <- 0..(height - 1), {x, y} != {pos_x, pos_y} do
      reduce({x - pos_x, y - pos_y})
    end
    |> Enum.uniq()
  end

  def reduce({0, y}), do: {0, div(y, abs(y))}
  def reduce({x, 0}), do: {div(x, abs(x)), 0}

  def reduce({x, y}) do
    gcf = gcf(x, y)
    {div(x, gcf), div(y, gcf)}
  end

  def gcf(num1, num2) do
    gcf(factors(abs(num1)), factors(abs(num2)), 1)
  end

  def gcf(list1, list2, gcf) when list1 == [] or list2 == [], do: gcf
  def gcf([hd | rest1], [hd | rest2], _), do: gcf(rest1, rest2, hd)

  def gcf([hd1 | rest1] = list1, [hd2 | rest2] = list2, gcf) do
    # discard the smaller number
    if hd1 < hd2 do
      gcf(rest1, list2, gcf)
    else
      gcf(list1, rest2, gcf)
    end
  end

  def factors(num) do
    {low, high} =
      Enum.reduce_while(2..floor(num / 2), {[1], [num]}, fn
        n, {low, [highest | _] = high} when n < highest ->
          if rem(num, n) == 0 do
            new_low = [n | low]
            new_high = [div(num, n) | high]
            {:cont, {new_low, new_high}}
          else
            {:cont, {low, high}}
          end

        _, acc ->
          {:halt, acc}
      end)

    Enum.concat(Enum.reverse(low), high)
  end

  def build_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        case char do
          "." -> Map.put(acc, {x, y}, :empty)
          "#" -> Map.put(acc, {x, y}, :asteroid)
        end
      end)
    end)
  end
end
