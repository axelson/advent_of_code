defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  def input(filename) do
    {:ok, input} = File.read(filename)
    input
  end
end
