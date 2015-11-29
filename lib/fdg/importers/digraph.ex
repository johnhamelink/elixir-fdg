defmodule FDG.Importers.Digraph do
  @moduledoc ~S"""
  Allows Erlang Digraphs (acyclic ones in particular)
  to be parsed and converted into other formats.
  """

  @typedoc """
  Used to describe Erlang Digraphs
  """
  @type digraph_type :: {:digraph, integer, integer, integer, boolean()}

  @typedoc """
  Used to pass along the digraph along with the atoms of one of its
  vertices.
  """
  @type vertex_type :: {:vertex, digraph_type, atom()}

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
  @spec import(digraph_type) :: [FDG.Parser.node_type]
  def import(dag = {:digraph, _, _, _, _}) do
    dag
    |> find_root_vertex
    |> build_ast
  end

  @spec find_root_vertex(digraph_type) :: vertex_type
  defp find_root_vertex(dag = {:digraph, _, _, _, _}) do
    find_root_vertex(dag, :digraph.vertices(dag))
  end

  @spec find_root_vertex(digraph_type, [atom()]) :: vertex_type
  defp find_root_vertex(dag, vertices = [head | tail]) when is_list(vertices) and is_atom(head) do
    case :digraph.in_degree(dag, head) do
      0 -> {:vertex, dag, head}
      _ -> find_root_vertex(dag, tail)
    end
  end

  @spec build_ast(vertex_type) :: FDG.Parser.node_type
  defp build_ast({:vertex, dag, vertex}) do
    {_atom, [label: root_label]} = :digraph.vertex(dag, vertex)
    [node: [
        label: root_label,
        children: build_ast({:vertices, dag, :digraph.out_neighbours(dag, vertex)}) |> List.flatten 
      ]
    ]
  end

  @spec build_ast({:vertices, digraph_type, []}) :: []
  defp build_ast({:vertices, _dag, []}), do: []

  @spec build_ast({:vertices, digraph_type, [vertex_type]}) :: [FDG.Parser.node_type]
  defp build_ast({:vertices, dag, [ head | tail]}) when is_atom(head) do
    [
      build_ast({:vertex, dag, head}),
      build_ast({:vertices, dag, tail})
    ]
  end

end
