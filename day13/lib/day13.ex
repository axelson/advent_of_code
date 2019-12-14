defmodule Day13 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    {tiles, _score} = run()

    Map.values(tiles)
    |> Enum.count(&match?(2, &1))
  end

  def part2(opts \\ []) do
    draw? = Keyword.get(opts, :draw?, false)

    tiles = %{}

    prog = build_prog()

    me = self()

    pid =
      spawn_link(fn ->
        prog
        |> Prog.set_input(me)
        |> Prog.set_output(me)
        |> Prog.store_pos(0, 2)
        |> Prog.execute_prog()
      end)

    if draw? do
      :timer.apply_interval(300, Process, :send, [self(), :draw, []])
    end

    {tiles, score} = run_game(pid, tiles, 0)

    if draw? do
      print(tiles, score)
    end

    score
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

    run_game(pid, tiles, 0)
  end

  def run_game(pid, tiles, score) do
    case receive_output([], tiles, score, pid) do
      [-1, 0, score] ->
        run_game(pid, tiles, score)

      [x, y, id] ->
        tiles = Map.put(tiles, {x, y}, id)
        run_game(pid, tiles, score)

      :done ->
        {tiles, score}
    end
  end

  def receive_output(received, _tiles, _score, _pid) when length(received) == 3,
    do: Enum.reverse(received)

  def receive_output(received, tiles, score, pid) when is_list(received) do
    receive do
      :draw ->
        unless Enum.empty?(tiles) do
          print(tiles, score)
        end

        receive_output(received, tiles, score, pid)

      :input_req ->
        input = bot_input(tiles)
        send(pid, input)
        receive_output(received, tiles, score, pid)

      :done ->
        :done

      x ->
        receive_output([x | received], tiles, score, pid)
    end
  end

  def bot_input(tiles) do
    {ball_pos, paddle_pos} =
      Enum.reduce_while(tiles, {nil, nil}, fn
        _, {ball_pos, paddle_pos} when not is_nil(ball_pos) and not is_nil(paddle_pos) ->
          {:halt, {ball_pos, paddle_pos}}

        {{x, y}, id}, {ball_pos, paddle_pos} ->
          case tile_id(id) do
            :ball -> {:cont, {{x, y}, paddle_pos}}
            :paddle -> {:cont, {ball_pos, {x, y}}}
            _ -> {:cont, {ball_pos, paddle_pos}}
          end
      end)

    {ball_x, _} = ball_pos
    {paddle_x, _} = paddle_pos
    diff = ball_x - paddle_x

    cond do
      diff < 0 -> -1
      diff == 0 -> 0
      diff > 0 -> 1
    end
  end

  def print(tiles, score) do
    IO.puts(IO.ANSI.clear())
    IO.puts("Score: #{score}")
    Advent.print_grid(tiles, fn id -> print_tile(id) end)
  end

  def print_tile(id) do
    case tile_id(id) do
      :empty -> " "
      :wall -> Advent.print_black(" ")
      :block -> "■"
      :paddle -> "▬"
      :ball -> IO.ANSI.color(5, 0, 0) <> "■" <> IO.ANSI.reset()
    end
  end

  def joystick_to_input("l"), do: -1
  def joystick_to_input("k"), do: 0
  def joystick_to_input("j"), do: 1

  def tile_id(nil), do: :empty
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
