defmodule OreParser do
  import NimbleParsec

  # Example combinations:
  # 10 ORE => 10 A
  # 1 ORE => 1 B
  # 7 A, 1 B => 1 C
  # 7 A, 1 C => 1 D
  # 7 A, 1 D => 1 E
  # 7 A, 1 E => 1 FUEL

  connector = ignore(string(" => ")) |> tag(:connector)

  count = integer(min: 1, max: 3)

  element = ascii_string([?A..?Z], min: 1, max: 5)

  count_element =
    count
    |> ignore(string(" "))
    |> concat(element)
    |> tag(:count_element)

  right =
    connector
    |> concat(count_element)
    |> tag(:rhs)

  reaction =
    repeat(
      choice([
        count_element,
        ignore(string(", "))
      ])
    )
    |> concat(right)
    |> eos()

  defparsec(:reaction, reaction)

  defparsec(:integer, integer(min: 1) |> unwrap_and_tag(:integer))
  defparsec(:integerp, integer(min: 1))
end
