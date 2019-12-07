defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  describe "required_fuel/1" do
    import Day1, only: [required_fuel: 1]

    test "sample values" do
      assert required_fuel(12) == 2
      assert required_fuel(14) == 2
      assert required_fuel(1969) == 654
      assert required_fuel(100_756) == 33583
    end
  end
end
