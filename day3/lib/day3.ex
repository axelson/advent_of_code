defmodule Day3 do
  alias Day3.Claim

  def run() do
    Advent.input("day3_input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&Claim.parse/1)
    |> Enum.flat_map(&Claim.coords/1)
    |> Enum.reduce(%{}, fn coord, claimed ->
      Map.update(claimed, coord, 1, &(&1 + 1))
    end)
    |> Enum.filter(fn {_, val} -> val > 1 end)
    |> Enum.map(fn {coord, _} -> coord end)
    |> length()
  end
end
