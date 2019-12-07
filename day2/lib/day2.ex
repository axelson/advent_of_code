defmodule Day2 do
  # @file_path Path.join(__DIR__, "short")
  @file_path Path.join(__DIR__, "input")

  def part1 do
    prog =
      Advent.comma_input(@file_path)
      |> Enum.map(&String.to_integer/1)
      |> Prog.intcodes_to_prog()
      |> restore_gravity_assist_program()
      |> Prog.execute_prog()

    Prog.to_intcodes(prog)
    |> hd()
  end

  def restore_gravity_assist_program(prog) do
    # replace position 1 with the value 12
    prog = Prog.store_pos(prog, 1, 12)
    # replace position 2 with the value 2
    Prog.store_pos(prog, 2, 2)
  end

  def execute_intcodes(intcodes) do
    Prog.intcodes_to_prog(intcodes)
    |> Prog.execute_prog()
    |> Prog.to_intcodes()
  end
end
