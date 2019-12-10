defmodule Prog do
  require Logger
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

    cur_code =
      get_pos(prog, cur_pointer)
      |> to_opcode()

    execute_instruction(prog, cur_code)
    |> execute_prog()
  end

  def to_opcode(code) do
    Integer.digits(code)
    |> Enum.take(-2)
    |> Integer.undigits()
  end

  def execute_instruction(prog, code)

  # halt
  def execute_instruction(prog, 99), do: %__MODULE__{prog | halted?: true}

  # add
  def execute_instruction(prog, 1) do
    [param1, param2, {:position, dest}] = get_parameters(prog, 3)

    num1 = read_param(prog, param1)
    num2 = read_param(prog, param2)

    result = num1 + num2

    log(
      "ADD  : #{inspect(param1)}=#{num1}, #{inspect(param2)}=#{num2}, #{inspect(dest)} = #{result}"
    )

    prog
    |> store_pos(dest, result)
    |> increment_pointer(4)
  end

  # mult
  def execute_instruction(prog, 2) do
    [param1, param2, {:position, dest}] = get_parameters(prog, 3)

    num1 = read_param(prog, param1)
    num2 = read_param(prog, param2)

    result = num1 * num2
    log("MULT : #{inspect(param1)}, #{inspect(param2)}, #{inspect(dest)} = #{result}")

    prog
    |> store_pos(dest, result)
    |> increment_pointer(4)
  end

  # input
  def execute_instruction(prog, 3) do
    [{:position, dest}] = get_parameters(prog, 1)

    value =
      IO.gets("Enter input: ")
      |> String.trim()
      |> String.to_integer()

    log("INPUT: #{inspect(dest)} = #{value}")

    prog
    |> store_pos(dest, value)
    |> increment_pointer(2)
  end

  # output
  def execute_instruction(prog, 4) do
    [arg1] = get_parameters(prog, 1)

    value = read_param(prog, arg1)
    IO.puts("output: #{value}")

    prog
    |> increment_pointer(2)
  end

  def execute_instruction(prog, instruction) do
    Logger.warn("prog: #{inspect(prog, pretty: true)}")
    raise "Unhandled instruction: #{instruction}"
  end

  def get_parameters(%__MODULE__{} = prog, num_parameters) do
    for offset <- 1..num_parameters do
      get_parameter(prog, offset)
    end
  end

  def get_parameter(%__MODULE__{} = prog, offset) do
    %__MODULE__{cur_pointer: cur_pointer} = prog

    [a, b, c, _, _] =
      get_pos(prog, cur_pointer)
      |> Integer.digits()
      |> pad_digits()

    param = get_pos(prog, cur_pointer + offset)

    case Enum.at([c, b, a], offset - 1) do
      0 -> {:position, param}
      1 -> {:immediate, param}
    end
  end

  def read_param(_prog, {:immediate, param}), do: param

  def read_param(prog, {:position, param}) do
    get_pos(prog, param)
  end

  defp pad_digits(digits) when length(digits) < 5, do: pad_digits([0 | digits])
  defp pad_digits(digits), do: digits

  def get_pos(%__MODULE__{} = prog, address) do
    %__MODULE__{codes: codes} = prog
    Map.fetch!(codes, address)
  end

  def store_pos(%__MODULE__{} = prog, address, value) do
    %__MODULE__{codes: codes} = prog
    codes = Map.put(codes, address, value)
    %__MODULE__{prog | codes: codes}
  end

  def increment_pointer(%__MODULE__{} = prog, amount) do
    %__MODULE__{cur_pointer: cur_pointer} = prog
    %__MODULE__{prog | cur_pointer: cur_pointer + amount}
  end

  def to_intcodes(%__MODULE__{} = prog) do
    %__MODULE__{codes: codes} = prog

    addresses =
      Map.keys(codes)
      |> Enum.sort()

    Enum.reduce(addresses, [], fn address, acc ->
      [Map.fetch!(codes, address) | acc]
    end)
    |> Enum.reverse()
  end

  # defp log(output), do: IO.puts(output)
  defp log(_output), do: nil
end
