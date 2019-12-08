defmodule Day8 do
  @file_path Path.join(__DIR__, "input")

  def part1(width \\ 25, height \\ 6) do
    Advent.input(@file_path)
    |> String.trim()
    |> corruption_check(width, height)
  end

  def corruption_check(input, width, height) do
    image = parse_lines(input, width, height)

    layer =
      Enum.min_by(image, fn layer ->
        count_digits(layer, 0)
      end)

    count_digits(layer, 1) * count_digits(layer, 2)
  end

  def parse_lines(input, width, height) do
    input
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width * height)
    |> Enum.map(fn layer ->
      Enum.chunk_every(layer, width)
    end)
  end

  def count_digits([], _digit), do: 0

  def count_digits([list | rest], digit) when is_list(list) do
    count_digits(list, digit) + count_digits(rest, digit)
  end

  def count_digits([digit | rest], digit) do
    1 + count_digits(rest, digit)
  end

  def count_digits([_ | rest], digit), do: count_digits(rest, digit)
end
