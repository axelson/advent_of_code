defmodule Day5Test do
  use ExUnit.Case, async: true
  doctest Day5

  describe "execute_intcodes/1" do
    import Day5, only: [execute_intcodes: 1]

    test "sample values" do
      assert execute_intcodes([1002, 4, 3, 4, 33]) == [1002, 4, 3, 4, 99]
      assert execute_intcodes([1101, 100, -1, 4, 0]) == [1101, 100, -1, 4, 99]
      # assert execute_intcodes([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
      # assert execute_intcodes([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
      # assert execute_intcodes([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
      # assert execute_intcodes([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end
  end

  # test "part 1 answer" do
  #   assert Day5.part1() == 5_434_663
  # end

  # test "part 2 answer" do
  #   assert Day5.part2() == 4559
  # end
end
