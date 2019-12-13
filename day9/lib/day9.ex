defmodule Day9 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    build_prog()
  end

  def build_prog do
    Advent.comma_input(@file_path)
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()

    # |> Prog.set_quiet()
  end

  def execute_intcodes(intcodes) do
    Prog.intcodes_to_prog(intcodes)
    |> Prog.execute_prog()
    |> Prog.to_intcodes()
  end
end
