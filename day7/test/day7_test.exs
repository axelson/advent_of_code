defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "part 1 answer" do
    assert Day7.part1() == 92663
  end

  test "part 2 answer" do
    assert Day7.part2() == 14_365_052
  end
end
