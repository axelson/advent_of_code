defmodule Board do
  defstruct [:coords, :distances, :intersections]

  def new do
    %__MODULE__{coords: %{}, distances: %{}, intersections: []}
  end

  def add_wire(%__MODULE__{} = board, wire_id, wire_commands) do
    commands = Enum.map(wire_commands, &parse_wire_command/1)

    {board, {_pos, _distance}} =
      commands
      |> Enum.reduce({board, {{0, 0}, 0}}, fn command, {board, {pos, distance}} ->
        record_command(board, wire_id, {pos, distance}, command)
      end)

    board
  end

  def record_command(%__MODULE__{} = board, _wire_id, {pos, distance}, {_, 0}) do
    {board, {pos, distance}}
  end

  def record_command(%__MODULE__{} = board, wire_id, {pos, distance}, {direction, num}) do
    next_pos = next_pos(direction, pos)
    next_distance = distance + 1
    board = record_pos(board, {next_pos, next_distance}, wire_id)

    record_command(board, wire_id, {next_pos, next_distance}, {direction, num - 1})
  end

  def record_pos(%__MODULE__{} = board, {pos, distance}, wire_id) do
    %__MODULE__{coords: coords, distances: distances, intersections: intersections} = board
    coords = Map.update(coords, pos, [wire_id], &[wire_id | &1])
    distances = Map.update(distances, pos, [{wire_id, distance}], &[{wire_id, distance} | &1])
    board = %__MODULE__{board | coords: coords, distances: distances}

    case Map.get(coords, pos) do
      [_] ->
        board

      wire_ids ->
        if length(Enum.uniq(wire_ids)) == 2 do
          %__MODULE__{board | intersections: [pos | intersections]}
        else
          board
        end
    end
  end

  def get_pos(%__MODULE__{coords: coords}, pos), do: Map.get(coords, pos)
  def get_distances(%__MODULE__{distances: distances}, pos), do: Map.get(distances, pos)

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
