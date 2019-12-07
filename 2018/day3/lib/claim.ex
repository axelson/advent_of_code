defmodule Day3.Claim do
  defstruct [:id, :x, :y, :width, :height]

  def parse("#" <> rest) do
    {id, rest} = Integer.parse(rest)
    <<" @ ", rest::binary>> = rest

    {x, rest} = Integer.parse(rest)
    <<",", rest::binary>> = rest
    {y, rest} = Integer.parse(rest)

    <<": ", rest::binary>> = rest

    {width, rest} = Integer.parse(rest)
    <<"x", rest::binary>> = rest
    {height, rest} = Integer.parse(rest)
    "" = rest

    %__MODULE__{
      id: id,
      x: x,
      y: y,
      width: width,
      height: height
    }
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
