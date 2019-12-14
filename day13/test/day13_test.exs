defmodule Day13Test do
  use ExUnit.Case, async: true
  doctest Day13

  test "part1 answer" do
    assert Day13.part1() == 273
  end

  test "part2 answer" do
    assert Day13.part2() == 13140
  end
end
