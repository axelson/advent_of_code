defmodule Robot do
  defstruct [:panels, :pos, :facing]

  def new do
    %__MODULE__{panels: %{}, pos: {0, 0}, facing: 0}
  end

  def command(%__MODULE__{} = robot, {:turn, turn_dir}) do
    %__MODULE__{facing: facing} = robot
    new_facing = turn(facing, turn_dir)

    %__MODULE__{robot | facing: new_facing}
    |> advance()
  end

  def advance(%__MODULE__{} = robot) do
    %__MODULE__{facing: facing, pos: {x, y}} = robot

    new_pos =
      case facing do
        0 -> {x, y + 1}
        1 -> {x + 1, y}
        2 -> {x, y - 1}
        3 -> {x - 1, y}
      end

    %__MODULE__{robot | pos: new_pos}
  end

  def read_color(%__MODULE__{} = robot) do
    %__MODULE__{panels: panels, pos: pos} = robot

    Map.get(panels, pos, 0)
  end

  def paint_color(%__MODULE__{} = robot, color) when color in [0, 1] do
    %__MODULE__{panels: panels, pos: pos} = robot
    panels = Map.put(panels, pos, color)
    %__MODULE__{robot | panels: panels}
  end

  def turn(0, 0), do: 3
  def turn(direction, 0), do: direction - 1
  def turn(3, 1), do: 0
  def turn(direction, 1), do: direction + 1
end
