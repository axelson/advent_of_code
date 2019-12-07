defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  def input(filename) do
    {:ok, input} = File.read(filename)
    input
  end

  def linewise_input(filename) do
    input(filename)
    |> String.split("\n", trim: true)
  end

  def comma_input(filename) do
    input(filename)
    |> String.trim()
    |> String.split(",")
  end
end
