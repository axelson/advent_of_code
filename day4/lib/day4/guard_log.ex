defmodule Day4.GuardLog do
  defstruct [:year, :month, :day, :hour, :minute, :id, :type, :raw]

  def parse(input) do
    <<"[", rest::binary>> = input
    {year, rest} = Integer.parse(rest)
    <<"-", rest::binary>> = rest
    {month, rest} = Integer.parse(rest)
    <<"-", rest::binary>> = rest
    {day, rest} = Integer.parse(rest)

    <<" ", rest::binary>> = rest

    {hour, rest} = Integer.parse(rest)
    <<":", rest::binary>> = rest
    {minute, rest} = Integer.parse(rest)
    <<"] ", message::binary>> = rest

    id =
      case message do
        <<"Guard #", rest::binary>> -> Integer.parse(rest) |> elem(0)
        _ -> :unknown
      end

    type =
      case message do
        <<"Guard #", _rest::binary>> -> :begin
        "falls asleep" -> :asleep
        "wakes up" -> :wake
      end

    %__MODULE__{
      id: id,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      type: type,
      raw: input
    }
  end

  def sort(a, b) do
    cond do
      a.year < b.year -> true
      a.year > b.year -> false
      a.month < b.month -> true
      a.month > b.month -> false
      a.day < b.day -> true
      a.day > b.day -> false
      a.hour < b.hour -> true
      a.hour > b.hour -> false
      a.minute < b.minute -> true
      a.minute > b.minute -> false
      true -> true
    end
  end
end
