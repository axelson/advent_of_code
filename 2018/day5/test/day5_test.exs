defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "parses" do
    input = "dabAcCaCBAcCcaDA"
    expected = "dabCBAcaDA"
    assert Day5.reduce(input) == expected
  end

  test "parses 2" do
    input = "abBA"
    expected = ""
    assert Day5.reduce(input) == expected
  end

  test "reduces out of order" do
    input = "ABba"
    expected = ""
    assert Day5.reduce(input) == expected
  end

  test "scrub scrubs a's" do
    assert Day5.scrub('abcA', ?a) == 'bc'
  end
end
