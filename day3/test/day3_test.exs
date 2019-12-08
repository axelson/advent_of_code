defmodule Day3Test do
  use ExUnit.Case, async: true
  doctest Day3

  describe "distance/1" do
    import Day3, only: [distance: 1]

    test "sample values" do
      assert distance("""
             R75,D30,R83,U83,L12,D49,R71,U7,L72
             U62,R66,U55,R34,D71,R55,D58,R83
             """) == 159

      assert distance("""
             R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
             U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
             """) == 135
    end
  end

  test "part 1 answer" do
    assert Day3.part1() == 248
  end

  describe "part2_distance/2" do
    import Day3, only: [part2_distance: 1]

    test "sample values" do
      assert part2_distance("""
             R75,D30,R83,U83,L12,D49,R71,U7,L72
             U62,R66,U55,R34,D71,R55,D58,R83
             """) == 610

      assert part2_distance("""
             R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
             U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
             """) == 410
    end
  end

  test "part 2 answer" do
    assert Day3.part2() == 28580
  end
end
