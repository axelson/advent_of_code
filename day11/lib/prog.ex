defmodule Prog do
  require Logger

  defstruct [
    :codes,
    :cur_pointer,
    :halted?,
    :last_output,
    :input_dest,
    :output_dest,
    :quiet?,
    :relative_base
  ]

  def intcodes_to_prog(intcodes) when is_list(intcodes) do
    codes =
      intcodes
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {intcode, index}, acc ->
        Map.put(acc, index, intcode)
      end)

    %__MODULE__{
      codes: codes,
      cur_pointer: 0,
      halted?: false,
      last_output: nil,
      output_dest: nil,
      relative_base: 0
    }
  end

  def execute_prog(%__MODULE__{halted?: true} = prog) do
    %__MODULE__{output_dest: output_dest} = prog

    try do
      send(output_dest, :done)
    rescue
      _e -> :ok
    end

    prog
  end

  def execute_prog(%__MODULE__{} = prog) do
    prog
    |> step()
    |> execute_prog()
  end

  def step(%__MODULE__{halted?: true} = prog), do: prog

  def step(%__MODULE__{} = prog) do
    %__MODULE__{cur_pointer: cur_pointer} = prog

    cur_code =
      get_pos(prog, cur_pointer)
      |> to_opcode()

    execute_instruction(prog, cur_code)
  end

  def set_quiet(%__MODULE__{} = prog), do: %__MODULE__{prog | quiet?: true}

  def set_output(%__MODULE__{} = prog, output_dest) do
    %__MODULE__{prog | output_dest: output_dest}
  end

  def set_input(%__MODULE__{} = prog, input_dest) do
    %__MODULE__{prog | input_dest: input_dest}
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
    [param1, param2, param3] = get_parameters(prog, 3)

    num1 = read_param(prog, param1, :val)
    num2 = read_param(prog, param2, :val)
    dest = read_param(prog, param3, :pos)

    result = num1 + num2

    log(
      "ADD  : (#{ip(param1, num1)}, #{ip(param2, num2)}, #{ip(param3, dest)} = #{result}) => #{
        dest
      }"
    )

    prog
    |> store_pos(dest, result)
    |> increment_pointer(4)
  end

  # mult
  def execute_instruction(prog, 2) do
    [param1, param2, param3] = get_parameters(prog, 3)

    num1 = read_param(prog, param1, :val)
    num2 = read_param(prog, param2, :val)
    dest = read_param(prog, param3, :pos)

    result = num1 * num2

    log(
      "MULT : (#{ip(param1, num1)}, #{ip(param2, num2)}, #{ip(param3, dest)} = #{result}) => #{
        dest
      }"
    )

    prog
    |> store_pos(dest, result)
    |> increment_pointer(4)
  end

  # input
  def execute_instruction(prog, 3) do
    [param1] = get_parameters(prog, 1)
    dest = read_param(prog, param1, :pos)

    value = read_input(prog)

    log("INPUT: #{ip(param1, dest)}, #{value} => #{inspect(dest)}")

    prog
    |> store_pos(dest, value)
    |> increment_pointer(2)
  end

  # output
  def execute_instruction(prog, 4) do
    [param1] = get_parameters(prog, 1)

    value = read_param(prog, param1, :val)
    log("OUTP : #{ip(param1, value)} -> #{value}")
    prog = write_output(prog, value)

    prog
    |> increment_pointer(2)
  end

  # jump-if-true
  def execute_instruction(prog, 5) do
    [param1, param2] = get_parameters(prog, 2)
    num1 = read_param(prog, param1, :val)
    dest = read_param(prog, param2, :val)

    log("JMPT : = (#{ip(param1, num1)}, #{ip(param2, dest)}) => #{dest}")

    if num1 != 0 do
      %__MODULE__{prog | cur_pointer: dest}
    else
      prog
      |> increment_pointer(3)
    end
  end

  # jump-if-false
  def execute_instruction(prog, 6) do
    [param1, param2] = get_parameters(prog, 2)
    num1 = read_param(prog, param1, :val)
    dest = read_param(prog, param2, :val)

    log("JMPF : = (#{ip(param1, num1)}, #{ip(param2, dest)}) -> #{dest}")

    if num1 == 0 do
      %__MODULE__{prog | cur_pointer: dest}
    else
      prog
      |> increment_pointer(3)
    end
  end

  # less than
  def execute_instruction(prog, 7) do
    [param1, param2, param3] = get_parameters(prog, 3)

    num1 = read_param(prog, param1, :val)
    num2 = read_param(prog, param2, :val)
    dest = read_param(prog, param3, :pos)
    value = if num1 < num2, do: 1, else: 0

    log(
      "LESS : (#{ip(param1, num1)}, #{ip(param2, num2)}, #{ip(param3, dest)} = #{value}) => #{
        dest
      }"
    )

    prog
    |> store_pos(dest, value)
    |> increment_pointer(4)
  end

  # equals
  def execute_instruction(prog, 8) do
    [param1, param2, param3] = get_parameters(prog, 3)

    num1 = read_param(prog, param1, :val)
    num2 = read_param(prog, param2, :val)
    dest = read_param(prog, param3, :pos)
    value = if num1 == num2, do: 1, else: 0

    log(
      "EQL  : (#{ip(param1, num1)}, #{ip(param2, num2)}, #{ip(param3, dest)}) = #{value} => #{
        dest
      }"
    )

    prog
    |> store_pos(dest, value)
    |> increment_pointer(4)
  end

  # relative_base
  def execute_instruction(prog, 9) do
    %__MODULE__{relative_base: relative_base} = prog
    [param1] = get_parameters(prog, 1)

    num1 = read_param(prog, param1, :val)
    new = relative_base + num1
    prog = %__MODULE__{prog | relative_base: new}
    log("RELBS: #{ip(param1, num1)}, cur: #{relative_base} -> #{new}")

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
      2 -> {:relative, param}
    end
  end

  def read_param(_prog, {:immediate, param}, :val), do: param
  # def read_param(_prog, {:immediate, param}, :pos), do: param

  def read_param(_prog, {:position, param}, :pos), do: param

  def read_param(prog, {:position, param}, :val) do
    get_pos(prog, param)
  end

  def read_param(prog, {:relative, param}, :val) do
    %__MODULE__{relative_base: relative_base} = prog
    get_pos(prog, relative_base + param)
  end

  def read_param(prog, {:relative, param}, :pos) do
    %__MODULE__{relative_base: relative_base} = prog
    relative_base + param
  end

  defp pad_digits(digits) when length(digits) < 5, do: pad_digits([0 | digits])
  defp pad_digits(digits), do: digits

  def get_pos(%__MODULE__{} = prog, address) do
    %__MODULE__{codes: codes} = prog
    Map.get(codes, address, 0)
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

  defp read_input(%__MODULE__{} = prog) do
    %__MODULE__{input_dest: input_dest} = prog
    send(input_dest, :input_req)

    receive do
      x -> x
    end
  end

  defp write_output(prog, value) do
    %__MODULE__{output_dest: output_dest, quiet?: quiet?} = prog

    if !quiet? do
      IO.puts("output: #{value}")
    end

    # It's okay if the process we're sending to no longer exists
    try do
      send(output_dest, value)
    rescue
      _e -> :ok
    end

    %__MODULE__{prog | last_output: value}
  end

  defp ip(param, val) do
    "#{inspect(param)}=#{val}"
  end

  # defp log(output), do: IO.puts(output)
  defp log(_output), do: nil
end
