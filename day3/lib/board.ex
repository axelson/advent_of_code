defmodule Board do
  defstruct [:coords, :intersections]

  def new do
    %__MODULE__{coords: %{}, intersections: []}
  end

  def add_wire(%__MODULE__{} = board, wire_id, wire_commands) do
    commands = Enum.map(wire_commands, &parse_wire_command/1)

    {board, _pos} =
      commands
      |> Enum.reduce({board, {0, 0}}, fn command, {board, pos} ->
        record_command(board, wire_id, pos, command)
      end)

    board
  end

  def record_command(%__MODULE__{} = board, _wire_id, pos, {_, 0}), do: {board, pos}

  def record_command(%__MODULE__{} = board, wire_id, pos, {direction, num}) do
    next_pos = next_pos(direction, pos)
    board = record_pos(board, next_pos, wire_id)

    record_command(board, wire_id, next_pos, {direction, num - 1})
  end

  def record_pos(%__MODULE__{} = board, pos, wire_id) do
    %__MODULE__{coords: coords, intersections: intersections} = board
    coords = Map.update(coords, pos, [wire_id], &[wire_id | &1])
    board = %__MODULE__{board | coords: coords}

    case Map.get(coords, pos) do
      [_] ->
        board

      wire_ids ->
        if length(Enum.uniq(wire_ids)) >= 2 do
          %__MODULE__{board | intersections: [pos | intersections]}
        else
          board
        end
    end
  end

  def get_pos(%__MODULE__{coords: coords}, pos), do: Map.get(coords, pos)

  defp next_pos(:up, {x, y}), do: {x, y - 1}
  defp next_pos(:right, {x, y}), do: {x + 1, y}
  defp next_pos(:down, {x, y}), do: {x, y + 1}
  defp next_pos(:left, {x, y}), do: {x - 1, y}

  for {char, direction} <- [{"U", :up}, {"R", :right}, {"D", :down}, {"L", :left}] do
    def parse_wire_command(unquote(char) <> num_string) do
      {unquote(direction), String.to_integer(num_string)}
    end
  end
end
