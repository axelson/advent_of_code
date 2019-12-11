defmodule Day10Test do
  use ExUnit.Case, async: true
  doctest Day10

  test "factors" do
    assert Day10.factors(20) == [1, 2, 4, 5, 10, 20]
    assert Day10.factors(12) == [1, 2, 3, 4, 6, 12]
    assert Day10.factors(33) == [1, 3, 11, 33]
  end

  test "gcf" do
    assert Day10.gcf(6, 8) == 2
    assert Day10.gcf(6, 63) == 3
    assert Day10.gcf(6, 24) == 6
    assert Day10.gcf(2, -4) == 2
    assert Day10.gcf(-4, 2) == 2
  end

  test "reduce" do
    assert Day10.reduce({6, 24}) == {1, 4}
    assert Day10.reduce({24, 32}) == {3, 4}
    assert Day10.reduce({0, 2}) == {0, 1}
    assert Day10.reduce({-1, 0}) == {-1, 0}
    assert Day10.reduce({-4, 2}) == {-2, 1}
  end

  describe "gen_angles/3" do
    import Day10, only: [gen_angles: 3]

    test "sample values" do
      # #..
      # ...
      # ...
      actual = Enum.sort(gen_angles({0, 0}, 3, 3))

      expected =
        Enum.sort([
          {1, 0},
          {2, 1},
          {1, 1},
          {0, 1},
          # {2, 2} => {1, 1}
          {1, 2}
          # {0, 2} => {0, 1}
        ])

      assert actual == expected
    end

    test "sample values for 4x4" do
      # .#..
      # ....
      # ....
      actual = Enum.sort(gen_angles({1, 0}, 4, 3))

      expected =
        Enum.sort([
          {-1, 0},
          {1, 0},
          {-1, 1},
          {0, 1},
          {1, 1},
          {2, 1},
          {-1, 2},
          {1, 2}
        ])

      assert actual == expected
    end
  end

  describe "asteroid_counts/1" do
    import Day10, only: [asteroid_counts: 1]

    test "sample values" do
      counts =
        asteroid_counts("""
        .#..#
        .....
        #####
        ....#
        ...##
        """)

      {width, height} = {5, 5}

      str =
        for y <- 0..(height - 1) do
          for x <- 0..(width - 1) do
            Map.get(counts, {x, y}, ".")
          end
          |> Enum.join()
        end
        |> Enum.join("\n")

      assert str == """
             .7..7
             .....
             67775
             ....7
             ...87\
             """

      input = """
      ......#.#.
      #..#.#....
      ..#######.
      .#.#.###..
      .#..#.....
      ..#....#.#
      #..#....#.
      .##.#..###
      ##...#..#.
      .#....####
      """

      assert Day10.best(input) == {{5, 8}, 33}

      input = """
      #.#...#.#.
      .###....#.
      .#....#...
      ##.#.#.#.#
      ....#.#.#.
      .##..###.#
      ..#...##..
      ..##....##
      ......#...
      .####.###.
      """

      assert Day10.best(input) == {{1, 2}, 35}

      input = """
      .#..#..###
      ####.###.#
      ....###.#.
      ..###.##.#
      ##.##.#.#.
      ....###..#
      ..#.#..#.#
      #..#.#.###
      .##...##.#
      .....#.#..
      """

      assert Day10.best(input) == {{6, 3}, 41}

      input = """
      .#..##.###...#######
      ##.############..##.
      .#.######.########.#
      .###.#######.####.#.
      #####.##.#.##.###.##
      ..#####..#.#########
      ####################
      #.####....###.#.#.##
      ##.#################
      #####.##.###..####..
      ..######..##.#######
      ####.##.####...##..#
      .#####..#.######.###
      ##...#.##########...
      #.##########.#######
      .####.#.###.###.#.##
      ....##.##.###..#####
      .#.#.###########.###
      #.#.#.#####.####.###
      ###.##.####.##.#..##
      """

      assert Day10.best(input) == {{11, 13}, 210}
    end
  end

  test "part 1 answer" do
    assert Day10.part1() == 260
  end

  # test "part 2 answer" do
  #   assert Day2.part2() == 4559
  # end
end
