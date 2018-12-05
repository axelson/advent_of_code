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
    |> Enum.map(&{&1.id, Claim.coords(&1)})
    |> Enum.reduce(%Result{claimed: %{}, valid_ids: all_ids}, fn {id, coords}, result ->
      {conflicting_ids, claimed} =
        Enum.reduce(coords, {MapSet.new(), result.claimed}, fn coord, {conflicting_ids, claimed} ->
          Map.get_and_update(claimed, coord, fn
            nil ->
              {conflicting_ids, [id]}

            conflicts ->
              new_conflicts = [id | conflicts]
              conflicting_ids = MapSet.union(conflicting_ids, MapSet.new(new_conflicts))
              {conflicting_ids, new_conflicts}
          end)
        end)

      # now we have conflicting_ids and an updated claimed map
      valid_ids =
        conflicting_ids
        |> Enum.reduce(result.valid_ids, fn conflicting_id, valid_ids ->
          MapSet.delete(valid_ids, conflicting_id)
        end)

      %{result | valid_ids: valid_ids, claimed: claimed}
    end)
  end
end
