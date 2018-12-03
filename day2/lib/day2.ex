defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day2.hello()
      :world

  """
  def run do
    Advent.input("day2_input.txt")
    |> extract_ids()
    |> Enum.map(&count_letters/1)
    |> Enum.map(&two_and_three_count/1)
    |> checksum()
  end

  def part2 do
    ids =
      Advent.input("day2_input.txt")
      |> extract_ids()

    ids
    |> Enum.map(&find_top_jaro_distance(&1, ids))
    |> Enum.sort_by(fn {distance, _} -> distance end)
    |> Enum.max_by(fn {distance, _} -> distance end)
    |> extract_common_letters()
  end

  @doc """
  Find the highest jaro distance of this id with all other ids

  Note: this probably isn't the most performant method
  """
  def find_top_jaro_distance(id, other_ids) do
    other_ids
    |> Enum.reduce({0, {"", ""}}, fn
      ^id, acc ->
        acc

      other_id, {highest_distance, closest_id} = acc ->
        case String.jaro_distance(id, other_id) do
          distance when distance > highest_distance -> {distance, {id, other_id}}
          _ -> acc
        end
    end)
  end

  def extract_common_letters({_distance, {id1, id2}}) do
    extract_common_letters(String.codepoints(id1), String.codepoints(id2))
    |> Enum.join()
  end

  def extract_common_letters([], []), do: []

  def extract_common_letters([char | rest_id1], [char | rest_id2]) do
    [char | extract_common_letters(rest_id1, rest_id2)]
  end

  def extract_common_letters([_ | rest_id1], [_ | rest_id2]) do
    extract_common_letters(rest_id1, rest_id2)
  end

  def extract_ids(text), do: String.split(text, "\n", trim: true)

  def count_letters(box_id) do
    box_id
    |> String.codepoints()
    |> Enum.reduce(%{}, fn char, letters ->
      Map.update(letters, char, 1, &(&1 + 1))
    end)
  end

  def two_and_three_count(%{} = letters) do
    letters
    |> Enum.reduce({0, 0}, fn
      {_, 2}, {_, three_count} -> {1, three_count}
      {_, 3}, {two_count, _} -> {two_count, 1}
      _, acc -> acc
    end)
  end

  def checksum(count_tuples) do
    {two_count, three_count} =
      count_tuples
      |> Enum.reduce({0, 0}, fn
        {two_count, three_count}, {existing_two_count, existing_three_count} ->
          {two_count + existing_two_count, three_count + existing_three_count}
      end)

    two_count * three_count
  end
end
