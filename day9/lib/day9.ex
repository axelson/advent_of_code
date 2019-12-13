defmodule Day9 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    prog = build_prog()

    me = self()

    pid =
      spawn_link(fn ->
        prog
        |> Prog.set_output(me)
        |> Prog.execute_prog()
      end)

    send(pid, 1)

    receive_input()
  end

  def part2 do
    prog = build_prog()

    me = self()

    pid =
      spawn_link(fn ->
        prog
        |> Prog.set_output(me)
        |> Prog.execute_prog()
      end)

    send(pid, 2)

    receive_input()
  end

  def file_input, do: Advent.comma_input(@file_path)

  def build_prog(input \\ file_input()) do
    input
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()
    |> Prog.set_quiet()
  end

  def execute_intcodes(intcodes) do
    Prog.intcodes_to_prog(intcodes)
    |> Prog.execute_prog()
    |> Prog.to_intcodes()
  end

  def receive_input do
    receive do
      :done -> []
      output -> [output | receive_input()]
    end
  end
end
