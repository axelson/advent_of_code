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
