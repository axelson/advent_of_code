defmodule Day14 do
  @file_path Path.join(__DIR__, "input")

  def part1(input \\ Advent.input(@file_path)) do
    graph =
      input
      |> parse_reactions()
      |> to_graph()

    elements = :digraph_utils.topsort(graph)
    count_ore(graph, elements, %{"FUEL" => -1}) * -1
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

  def count_ore(_graph, ["ORE"], element_counts), do: Map.get(element_counts, "ORE")

  def count_ore(graph, [element | rest_elements], element_counts) do
    case Map.get(element_counts, element, 0) do
      cur_count when cur_count < 0 ->
        edges = :digraph.out_edges(graph, element)
        {_, result_count} = :digraph.vertex(graph, element)

        new_count = cur_count + result_count
        element_counts = Map.put(element_counts, element, new_count)

        # Update the element counts by running the reaction
        element_counts =
          Enum.reduce(edges, element_counts, fn edge, element_counts ->
            {_, ^element, source_element, source_count} = :digraph.edge(graph, edge)
            Map.update(element_counts, source_element, -source_count, &(&1 - source_count))
          end)

        count_ore(graph, [element | rest_elements], element_counts)

      _ ->
        count_ore(graph, rest_elements, element_counts)
    end
  end
end
