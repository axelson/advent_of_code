defmodule Day7 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    prog = build_prog()

    permutations([0, 1, 2, 3, 4])
    |> Enum.map(&execute_phases(&1, prog))
    |> Enum.max()
  end

  def part2 do
    prog = build_prog()

    permutations([5, 6, 7, 8, 9])
    |> Enum.map(&execute_phases(&1, prog))
    |> Enum.max()
  end

  def execute_phases(phase_inputs, prog) do
    [phase_a, phase_b, phase_c, phase_d, phase_e] = phase_inputs

    me = self()

    spawn_link(fn ->
      Process.register(self(), :a)

      prog
      |> Prog.set_output(:b)
      |> Prog.execute_prog()
    end)

    spawn_link(fn ->
      Process.register(self(), :b)

      prog
      |> Prog.set_output(:c)
      |> Prog.execute_prog()
    end)

    spawn_link(fn ->
      Process.register(self(), :c)

      prog
      |> Prog.set_output(:d)
      |> Prog.execute_prog()
    end)

    spawn_link(fn ->
      Process.register(self(), :d)

      prog
      |> Prog.set_output(:e)
      |> Prog.execute_prog()
    end)

    spawn_link(fn ->
      Process.register(self(), :e)

      prog =
        prog
        |> Prog.set_output(:a)
        |> Prog.execute_prog()

      send(me, prog.last_output)
    end)

    # Give processes time to startup and register
    Process.sleep(10)

    send(:a, phase_a)
    send(:b, phase_b)
    send(:c, phase_c)
    send(:d, phase_d)
    send(:e, phase_e)

    send(:a, 0)

    receive do
      x -> x
    end
  end

  def build_prog do
    Advent.comma_input(@file_path)
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()
    |> Prog.set_quiet()
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
