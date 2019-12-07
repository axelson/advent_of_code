defmodule Prog do
  defstruct [:codes, :cur_pointer, :halted?]

  def intcodes_to_prog(intcodes) when is_list(intcodes) do
    codes =
      intcodes
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {intcode, index}, acc ->
        Map.put(acc, index, intcode)
      end)

    %__MODULE__{codes: codes, cur_pointer: 0, halted?: false}
  end

  def execute_prog(%__MODULE__{halted?: true} = prog), do: prog

  def execute_prog(%__MODULE__{} = prog) do
    %__MODULE__{cur_pointer: cur_pointer} = prog

    cur_code = get_pos(prog, cur_pointer)

    execute_code(prog, cur_code)
    |> execute_prog()
  end

  def execute_code(prog, code)

  # halt
  def execute_code(prog, 99), do: %__MODULE__{prog | halted?: true}

  # add
  def execute_code(prog, 1) do
    {arg1, arg2, arg3} = get_arguments(prog, 3)

    num1 = get_pos(prog, arg1)
    num2 = get_pos(prog, arg2)
    dest = arg3

    result = num1 + num2

    prog
    |> store_pos(dest, result)
    |> increment_pointer(4)
  end

  # mult
  def execute_code(prog, 2) do
    {arg1, arg2, arg3} = get_arguments(prog, 3)

    num1 = get_pos(prog, arg1)
    num2 = get_pos(prog, arg2)
    dest = arg3

    result = num1 * num2

    prog
    |> store_pos(dest, result)
    |> increment_pointer(4)
  end

  def get_arguments(%__MODULE__{} = prog, 3) do
    %__MODULE__{cur_pointer: cur_pointer} = prog

    {
      get_pos(prog, cur_pointer + 1),
      get_pos(prog, cur_pointer + 2),
      get_pos(prog, cur_pointer + 3)
    }
  end

  def get_pos(%__MODULE__{} = prog, index) do
    %__MODULE__{codes: codes} = prog
    Map.fetch!(codes, index)
  end

  def store_pos(%__MODULE__{} = prog, index, value) do
    %__MODULE__{codes: codes} = prog
    codes = Map.put(codes, index, value)
    %__MODULE__{prog | codes: codes}
  end

  def increment_pointer(%__MODULE__{} = prog, amount) do
    %__MODULE__{cur_pointer: cur_pointer} = prog
    %__MODULE__{prog | cur_pointer: cur_pointer + amount}
  end

  def to_intcodes(%__MODULE__{} = prog) do
    %__MODULE__{codes: codes} = prog

    indexes =
      Map.keys(codes)
      |> Enum.sort()

    Enum.reduce(indexes, [], fn index, acc ->
      [Map.fetch!(codes, index) | acc]
    end)
    |> Enum.reverse()
  end
end
