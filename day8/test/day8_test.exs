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

  describe "message/3" do
    import Day8, only: [message: 3]

    test "sample values" do
      assert message("0222112222120000", 2, 2) == [["\e[40m \e[0m", " ", " ", "\e[40m \e[0m"]]
    end
  end

  test "part 2 answer" do
    assert Day8.part2() == [
             [
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               " ",
               " ",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m"
             ],
             "\n",
             [
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m"
             ],
             "\n",
             [
               " ",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m"
             ],
             "\n",
             [
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               " ",
               " ",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               " ",
               " ",
               " ",
               "\e[40m \e[0m"
             ],
             "\n",
             [
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m"
             ],
             "\n",
             [
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               " ",
               " ",
               " ",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m",
               "\e[40m \e[0m",
               " ",
               "\e[40m \e[0m"
             ]
           ]
  end
end
