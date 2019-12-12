defmodule Day7 do
  @file_path Path.join(__DIR__, "input")

  def part1() do
    prog = build_prog()

    {_, output} =
      permutations([0, 1, 2, 3, 4])
      |> Enum.map(fn phase_inputs ->
        output = execute_phases(prog, phase_inputs)
        {phase_inputs, output}
      end)
      |> Enum.max_by(fn {_phase_inputs, output} -> output end)

    output
  end

  def build_prog do
    Advent.comma_input(@file_path)
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()
    |> Prog.set_quiet()
  end

  def execute_phases(prog, phase_inputs) do
    Enum.reduce(phase_inputs, 0, fn phase_input, input ->
      [output] =
        prog
        |> Prog.set_input([phase_input, input])
        |> Prog.execute_prog()
        |> Prog.read_output()

      output
    end)
  end

  def execute_intcodes(intcodes) do
    Prog.intcodes_to_prog(intcodes)
    |> Prog.execute_prog()
    |> Prog.to_intcodes()
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
