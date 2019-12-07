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

  def part2 do
    prog =
      Advent.comma_input(@file_path)
      |> Enum.map(&String.to_integer/1)
      |> Prog.intcodes_to_prog()

    expected_output = 19_690_720

    for noun <- 0..99, verb <- 0..99, into: %{} do
      prog = restore_noun_verb(prog, noun, verb)
      output = produce_output(prog)

      if output == expected_output do
        answer = 100 * noun + verb
        {:ok, answer}
      else
        {:error, :skip}
      end
    end
    |> Map.get(:ok)
  end

  def produce_output(prog) do
    Prog.execute_prog(prog)
    |> Prog.to_intcodes()
    |> hd()
  end

  def restore_noun_verb(prog, noun, verb) do
    prog
    |> Prog.store_pos(1, noun)
    |> Prog.store_pos(2, verb)
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
