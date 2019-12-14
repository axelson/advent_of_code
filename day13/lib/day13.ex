defmodule Day13 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    tiles = run()

    Map.values(tiles)
    |> Enum.count(&match?(2, &1))
  end

  def run do
    tiles = %{}

    prog = build_prog()
    me = self()

    pid =
      spawn_link(fn ->
        prog
        |> Prog.set_input(me)
        |> Prog.set_output(me)
        |> Prog.execute_prog()
      end)

    run_game(pid, tiles)
  end

  def run_game(pid, tiles) do
    case receive_output([]) do
      [x, y, id] ->
        tiles = Map.put(tiles, {x, y}, id)
        run_game(pid, tiles)

      :done ->
        tiles
    end
  end

  def receive_output(received) when length(received) == 3, do: Enum.reverse(received)

  def receive_output(received) when is_list(received) do
    receive do
      :done -> :done
      x -> receive_output([x | received])
    end
  end

  def tile_id(0), do: :empty
  def tile_id(1), do: :wall
  def tile_id(2), do: :block
  def tile_id(3), do: :paddle
  def tile_id(4), do: :ball

  def file_input, do: Advent.comma_input(@file_path)

  def build_prog(input \\ file_input()) do
    input
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()
    |> Prog.set_quiet()
  end
end
