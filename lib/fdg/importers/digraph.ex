defmodule FDG.Importers.Digraph do

  @doc ~S"""
  Retrieves a `dag` (Directed acyclic graph), finds its root,
  and builds an AST from it by iterating through its direct
  neighbours.

  ## Examples:

    iex> dag = :digraph.new([:acyclic])
    iex> :digraph.add_vertex(dag, :a, [label: "A"])
    iex> :digraph.add_vertex(dag, :b, [label: "B"])
    iex> :digraph.add_vertex(dag, :c, [label: "C"])
    iex> :digraph.add_edge(dag, :a, :b)
    iex> :digraph.add_edge(dag, :a, :c)
    iex> FDG.Importers.Digraph.import(dag)
    [node: [label: "A",
      children: [
        node: [label: "C", children: []],
        node: [label: "B", children: []]
      ]
    ]]

  """
  @spec import(digraph_type) :: [node_type]
  def import(dag = {:digraph, _, _, _, _}) do
    dag
    |> find_root_vertex
    |> build_ast
  end

  defp find_root_vertex(dag = {:digraph, _, _, _, _}) do
    find_root_vertex(dag, :digraph.vertices(dag))
  end

  defp find_root_vertex(dag, vertices = [head | tail]) when is_list(vertices) and is_atom(head) do
    case :digraph.in_degree(dag, head) do
      0 -> {:vertex, dag, head}
      _ -> find_root_vertex(dag, tail)
    end
  end

  defp build_ast({:vertex, dag, vertex}) do
    {_atom, [label: root_label]} = :digraph.vertex(dag, vertex)
    [node: [
        label: root_label,
        children: build_ast({:vertices, dag, :digraph.out_neighbours(dag, vertex)}) |> List.flatten 
      ]
    ]
  end

  defp build_ast({:vertices, _dag, []}), do: []

  defp build_ast({:vertices, dag, [ head | tail]}) when is_atom(head) do
    [
      build_ast({:vertex, dag, head}),
      build_ast({:vertices, dag, tail})
    ]
  end

end
