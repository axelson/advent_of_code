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

  defmodule Result do
    defstruct [
      # A map where the key is the coord and the value is the ids that have that coord
      :claimed,
      :valid_ids
    ]
  end

  def part2() do
    claims =
      Advent.input("day3_input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&Claim.parse/1)

    all_ids =
      claims
      |> Enum.map(& &1.id)
      |> MapSet.new()

    claims
    |> Enum.flat_map(fn claim ->
      Claim.coords(claim)
      |> Enum.map(&{claim.id, &1})
    end)
    |> Enum.reduce(%Result{claimed: %{}, valid_ids: all_ids}, fn {id, coord}, result ->
      {conflicts, claimed} =
        Map.get_and_update(result.claimed, coord, fn
          nil -> {[], [id]}
          existing_ids -> {[id | existing_ids], [id | existing_ids]}
        end)

      valid_ids =
        conflicts
        |> Enum.reduce(result.valid_ids, fn conflicting_id, valid_ids ->
          MapSet.delete(valid_ids, conflicting_id)
        end)

      %Result{result | claimed: claimed, valid_ids: valid_ids}
    end)
  end
end
