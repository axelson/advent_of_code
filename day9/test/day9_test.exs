defmodule Day9Test do
  use ExUnit.Case, async: true
  doctest Day9

  test "sample 1" do
    intcodes = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]

    prog =
      Prog.intcodes_to_prog(intcodes)
      |> Prog.set_quiet()

    assert execute_prog(prog) == intcodes
  end

  test "sample 2" do
    intcodes = [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]

    prog =
      Prog.intcodes_to_prog(intcodes)
      |> Prog.set_quiet()

    assert [output] = execute_prog(prog)
    assert length(Integer.digits(output)) == 16
  end

  test "sample 3" do
    intcodes = [104, 1_125_899_906_842_624, 99]

    prog =
      Prog.intcodes_to_prog(intcodes)
      |> Prog.set_quiet()

    output = execute_prog(prog)
    assert output == [1_125_899_906_842_624]
  end

  test "samples" do
    import Day9, only: [execute_intcodes: 1]

    assert execute_intcodes([1002, 4, 3, 4, 33]) == [1002, 4, 3, 4, 99]
    assert execute_intcodes([1101, 100, -1, 4, 0]) == [1101, 100, -1, 4, 99]
    assert execute_intcodes([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
    assert execute_intcodes([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
    assert execute_intcodes([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
    assert execute_intcodes([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end

  test "part1" do
    assert Day9.part1() == [2_682_107_844]
  end

  defp execute_prog(prog) do
    prog = Prog.set_output(prog, self())

    spawn_link(fn ->
      Prog.execute_prog(prog)
    end)

    receive_input()
  end

  def receive_input do
    receive do
      :done -> []
      output -> [output | receive_input()]
    end
  end
end
