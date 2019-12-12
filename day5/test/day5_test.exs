defmodule Day5Test do
  use ExUnit.Case, async: true
  doctest Day5

  describe "execute_intcodes/1" do
    import Day5, only: [execute_intcodes: 1]

    test "sample values" do
      assert execute_intcodes([1002, 4, 3, 4, 33]) == [1002, 4, 3, 4, 99]
      assert execute_intcodes([1101, 100, -1, 4, 0]) == [1101, 100, -1, 4, 99]
      assert execute_intcodes([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
      assert execute_intcodes([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
      assert execute_intcodes([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
      assert execute_intcodes([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    test "part2 sample values" do
      assert ExUnit.CaptureIO.capture_io(fn ->
               StringIO.open("1\n", fn pid ->
                 intcodes = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]

                 Prog.intcodes_to_prog(intcodes)
                 |> Prog.set_input(pid)
                 |> Prog.execute_prog()
                 |> Prog.to_intcodes()
               end)
             end) == "output: 0\n"

      assert ExUnit.CaptureIO.capture_io(fn ->
               StringIO.open("8\n", fn pid ->
                 intcodes = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]

                 Prog.intcodes_to_prog(intcodes)
                 |> Prog.set_input(pid)
                 |> Prog.execute_prog()
                 |> Prog.to_intcodes()
               end)
             end) == "output: 1\n"
    end
  end

  test "part 1 answer" do
    assert ExUnit.CaptureIO.capture_io(fn ->
             StringIO.open("1\n", fn pid ->
               Day5.part1(pid)
             end)
           end) === """
           output: 0
           output: 0
           output: 0
           output: 0
           output: 0
           output: 0
           output: 0
           output: 0
           output: 0
           output: 7286649
           """
  end

  test "part 2 answer" do
    assert ExUnit.CaptureIO.capture_io(fn ->
             StringIO.open("5\n", fn pid ->
               Day5.part2(pid)
             end)
           end) === """
           output: 15724522
           """
  end
end
