defmodule Day5 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    Advent.comma_input(@file_path)
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()
    |> Prog.execute_prog()
  end

  def execute_intcodes(intcodes) do
    Prog.intcodes_to_prog(intcodes)
    |> Prog.execute_prog()
    |> Prog.to_intcodes()
  end
end
