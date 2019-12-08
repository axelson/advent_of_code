defmodule Day8 do
  @file_path Path.join(__DIR__, "input")

  def part1(width \\ 25, height \\ 6) do
    Advent.input(@file_path)
    |> String.trim()
    |> corruption_check(width, height)
  end

  def part2 do
    Advent.input(@file_path)
    |> String.trim()
    |> message(25, 6)
  end

  def message(input, width, height) do
    image = parse_lines(input, width, height)

    message =
      Enum.reduce(image, %{}, fn layer, acc ->
        layer
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {row, row_num}, acc ->
          row
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {col, col_num}, acc ->
            Map.update(acc, {row_num, col_num}, col, fn
              2 -> col
              current_value -> current_value
            end)
          end)
        end)
      end)

    for row <- 0..(height - 1), col <- 0..(width - 1) do
      message[{row, col}]
      |> to_printable()
    end
    |> Enum.chunk_every(25)
    |> Enum.intersperse("\n")
  end

  def to_printable(0), do: IO.ANSI.black_background() <> " " <> IO.ANSI.reset()
  def to_printable(1), do: " "

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
