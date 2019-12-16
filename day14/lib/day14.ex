defmodule Day14 do
  @file_path Path.join(__DIR__, "input")

  def part1(input \\ Advent.input(@file_path)) do
    graph =
      input
      |> parse_reactions()
      |> to_graph()

    elements = :digraph_utils.topsort(graph)
    element_counts = count_ore(graph, elements, %{"FUEL" => -1})
    -Map.get(element_counts, "ORE")
  end

  def part2(input \\ Advent.input(@file_path)) do
    graph =
      input
      |> parse_reactions()
      |> to_graph()

    ore = 1_000_000_000_000
    binary_search(graph, 0, ore)
  end

  def graph(input \\ Advent.input(@file_path)) do
    input
    |> parse_reactions()
    |> to_graph()
  end

  def parse_reactions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&to_reaction/1)
  end

  def to_reaction(line) do
    {:ok, matches, _, _, _, _} = OreParser.reaction(line)

    Enum.reduce(matches, {[], nil}, fn
      {:count_element, [count, element]}, {left, right} ->
        {[{element, count} | left], right}

      {:rhs, [connector: _, count_element: [count, element]]}, {left, _right} ->
        {left, {element, count}}
    end)
  end

  def to_graph(reactions) do
    graph = :digraph.new([:acyclic])
    :digraph.add_vertex(graph, "ORE", 1)

    for {_lhs, rhs} <- reactions, {element, count} <- [rhs] do
      :digraph.add_vertex(graph, element, count)
    end

    for {lhs, rhs} <- reactions,
        {result_element, _count} <- [rhs],
        {source_element, count} <- lhs do
      # Count is how many of the source element is needed for the result element
      :digraph.add_edge(graph, result_element, source_element, count)
    end

    graph
  end

  def start_to_fuel(graph, fuel, ore \\ 1_000_000_000_000) do
    elements = :digraph_utils.topsort(graph)
    element_counts = %{"FUEL" => fuel, "ORE" => ore}
    element_counts = count_ore(graph, elements, element_counts)
    -Map.get(element_counts, "ORE")
  end

  def binary_search(graph, min, max) do
    new_num = round((max - min) / 2) + min

    if new_num == min || new_num == max do
      min
    else
      result = start_to_fuel(graph, -new_num)

      cond do
        result == 0 -> new_num
        result < 0 -> binary_search(graph, new_num, max)
        result > 0 -> binary_search(graph, min, new_num)
      end
    end
  end

  def count_ore(_graph, ["ORE"], element_counts), do: element_counts

  # Need to change this to run the reaction until there is a negative count of the element (such as FUEL to start). That way it can be used to see if the given amount of fuel requires a certain amount of ore
  def count_ore(graph, [element | rest_elements], element_counts) do
    case Map.get(element_counts, element, 0) do
      cur_count when cur_count < 0 ->
        edges = :digraph.out_edges(graph, element)
        {_, result_count} = :digraph.vertex(graph, element)

        # times = cur_count * -1
        # How many times does the reaction need to be run to get this element to at least 0
        times = ceil(cur_count / result_count * -1)

        new_count = cur_count + result_count * times
        element_counts = Map.put(element_counts, element, new_count)

        # Update the element counts by running the reaction
        element_counts =
          Enum.reduce(edges, element_counts, fn edge, element_counts ->
            {_, ^element, source_element, source_count} = :digraph.edge(graph, edge)

            Map.update(
              element_counts,
              source_element,
              -source_count * times,
              &(&1 - source_count * times)
            )
          end)

        count_ore(graph, [element | rest_elements], element_counts)

      _ ->
        count_ore(graph, rest_elements, element_counts)
    end
  end
end
