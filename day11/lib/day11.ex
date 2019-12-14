defmodule Day11 do
  @file_path Path.join(__DIR__, "input")

  def part1 do
    prog = build_prog()

    me = self()

    pid =
      spawn_link(fn ->
        prog
        |> Prog.set_input(me)
        |> Prog.set_output(me)
        |> Prog.execute_prog()
      end)

    robot = execute_robot(Robot.new(), pid)
    map_size(robot.panels)
  end

  def part2 do
    prog = build_prog()

    me = self()

    pid =
      spawn_link(fn ->
        prog
        |> Prog.set_input(me)
        |> Prog.set_output(me)
        |> Prog.execute_prog()
      end)

    robot = execute_robot(Robot.new(), pid)

    Robot.print(robot)
    |> IO.puts()
  end

  def execute_robot(robot, computer) do
    receive do
      :done ->
        robot

      :input_req ->
        color = Robot.read_color(robot)
        send(computer, color)
        execute_robot(robot, computer)

      color ->
        robot = Robot.paint_color(robot, color)

        receive do
          turn_dir ->
            robot
            |> Robot.command({:turn, turn_dir})
            |> execute_robot(computer)
        end
    end
  end

  def file_input, do: Advent.comma_input(@file_path)

  def build_prog(input \\ file_input()) do
    input
    |> Enum.map(&String.to_integer/1)
    |> Prog.intcodes_to_prog()
    |> Prog.set_quiet()
  end
end
