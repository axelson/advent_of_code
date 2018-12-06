defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """

  @type entry :: {id :: integer, state_change, time :: any}
  @type state_change :: :begin | :wake | :asleep
  # @type guard :: {id}

  defmodule Guard do
    defstruct [:id, :total_time_asleep, :sleepiest_minute]
  end

  def run do
    Advent.linewise_input("short.txt")
    |> Enum.map(&Day4.GuardLog.parse/1)
    |> Enum.sort(&Day4.GuardLog.sort/2)
  end

  def part1 do
    file = "day4_input.txt"
    # file = "short.txt"

    {entries, _} =
      Advent.linewise_input(file)
      |> Enum.map(&Day4.GuardLog.parse/1)
      |> Enum.sort(&Day4.GuardLog.sort/2)
      |> Enum.reduce({[], :unknown}, fn log, {entries, most_recent_id} ->
        id =
          case log.id do
            :unknown -> most_recent_id
            id -> id
          end

        time = {log.year, log.month, log.day, log.hour, log.minute}
        entry = {id, log.type, time}

        {[entry | entries], id}
      end)

    sleepiest_guard = sleepiest_guard(entries)
    sleepiest_guard.id * sleepiest_guard.sleepiest_minute
  end

  defp sleepiest_guard(entries) do
    Enum.reverse(entries)
    |> Enum.group_by(fn {id, _, _} -> id end, fn {id, state_change, {_, _, _, _, minute}} ->
      {id, state_change, minute}
    end)
    |> Enum.reduce(%Guard{total_time_asleep: 0}, fn {id, entries}, sleepiest_guard ->
      # Need to produce a list of minutes asleep (in any given day)
      # Can then sum them to get the total time asleep per guard
      # And find the max to find when that guard is most likely to be asleep
      minute_log =
        entries
        |> Enum.reduce([], fn
          {_id, :begin, _time}, acc -> acc
          {id, :asleep, start_time}, acc -> [{start_time, :unknown} | acc]
          {id, :wake, etime}, [{stime, :unknown} | rest] -> [{stime, etime} | rest]
        end)
        |> Enum.flat_map(fn {start_minute, end_minute} ->
          expand_minutes(start_minute, end_minute)
        end)
        |> Enum.reduce(%{}, fn minute, minute_log ->
          Map.update(minute_log, minute, 1, &(&1 + 1))
        end)

      total_time_asleep = Enum.sum(Map.values(minute_log))

      {sleepiest_minute, _} =
        Enum.max_by(minute_log, fn {_minute, times_asleep} -> times_asleep end, fn -> {0, nil} end)

      if total_time_asleep > sleepiest_guard.total_time_asleep do
        %Guard{id: id, total_time_asleep: total_time_asleep, sleepiest_minute: sleepiest_minute}
      else
        sleepiest_guard
      end
    end)
  end

  # defp minutes({year, month, day, hour, minute})
  defp expand_minutes(time, time), do: []

  defp expand_minutes(start_minute, end_minute) do
    # build a list of minutes from start time to the end time by recursively adding to it
    [start_minute | expand_minutes(start_minute + 1, end_minute)]
  end
end
