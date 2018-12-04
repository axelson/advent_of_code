defmodule Day3.Claim do
  defstruct [:id, :x, :y, :width, :height]

  @digits ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  def parse("#" <> rest) do
    rest = String.codepoints(rest)

    {id, rest} = parse_digit(rest)

    [" ", "@", " " | rest] = rest

    {x, rest} = parse_digit(rest)
    ["," | rest] = rest
    {y, rest} = parse_digit(rest)

    [":", " " | rest] = rest

    {width, rest} = parse_digit(rest)
    ["x" | rest] = rest
    {height, rest} = parse_digit(rest)
    [] = rest

    %__MODULE__{
      id: id,
      x: x,
      y: y,
      width: width,
      height: height
    }
  end

  defp parse_digit(rest) do
    {digits, rest} = do_parse_digit(rest)
    {Enum.join(digits) |> String.to_integer(), rest}
  end

  defp do_parse_digit([digit | rest]) when digit in @digits do
    {digits, rest} = do_parse_digit(rest)
    {[digit | digits], rest}
  end

  defp do_parse_digit(rest) do
    {[], rest}
  end

  @doc """
  Returns a list of coordinates within this claim
  """
  def coords(%__MODULE__{} = claim) do
    %__MODULE__{x: x, y: y, width: width, height: height} = claim
    for x_coord <- x..(x + width - 1), y_coord <- y..(y + height - 1) do
      {x_coord, y_coord}
    end
  end
end
