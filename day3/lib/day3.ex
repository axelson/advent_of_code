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
      # Advent.input("short.txt")
      Advent.input("day3_input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&Claim.parse/1)

    maybe_valid_ids =
      claims
      |> Enum.map(& &1.id)
      |> MapSet.new()

    claims
    |> Enum.map(&{&1.id, Claim.coords(&1)})
    |> Enum.reduce(%Result{claimed: %{}, valid_ids: maybe_valid_ids}, fn {id, coords}, result ->
      {conflicting_ids, claimed} =
        Enum.reduce(coords, {[], result.claimed}, fn coord, {conflicting_ids, claimed} ->
          {conflicts, claimed} =
            Map.get_and_update(claimed, coord, fn
              nil ->
                {[], [id]}

              conflicts ->
                new_conflicts = [id | conflicts]
                {new_conflicts, new_conflicts}
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
