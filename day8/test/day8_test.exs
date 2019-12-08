defmodule Day8Test do
  use ExUnit.Case, async: true
  doctest Day8

  describe "corruption_check/1" do
    import Day8, only: [corruption_check: 3]

    test "sample values" do
      assert corruption_check("123456789012", 3, 2) == 1
      assert corruption_check("123451789012", 3, 2) == 2
      assert corruption_check("123411789012", 3, 2) == 3
      assert corruption_check("123211789012", 3, 2) == 6
    end
  end

  test "part 1 answer" do
    assert Day8.part1() == 2064
  end

  # describe "part2_distance/2" do
  #   import Day8, only: [part2_distance: 1]

  #   test "sample values" do
  #     assert part2_distance("""
  #            R75,D30,R83,U83,L12,D49,R71,U7,L72
  #            U62,R66,U55,R34,D71,R55,D58,R83
  #            """) == 610

  #     assert part2_distance("""
  #            R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
  #            U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
  #            """) == 410
  #   end
  # end

  # test "part 2 answer" do
  #   assert Day8.part2() == 28580
  # end
end
