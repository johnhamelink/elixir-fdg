defmodule FDG.Importers.Digraph do

  def import(dag = {:digraph, _, _, _, _}) do
    dag
    |> find_root_vertex
    |> build_ast
  end

  def find_root_vertex(dag = {:digraph, _, _, _, _}) do
    find_root_vertex(dag, :digraph.vertices(dag))
  end

  @doc ~S"""
  Loop through vertices and return the first one with no parent
  """
  def find_root_vertex(dag, vertices = [head | tail]) when is_list(vertices) and is_atom(head) do
    case :digraph.in_degree(dag, head) do
      0 -> {:vertex, dag, head}
      _ -> find_root_vertex(dag, tail)
    end
  end

  @doc ~S"""
  Find the vertex, retrieve it's direct children, and build an ast from it,
  then return a `node_tuple` comprising the vertex and it's descendants.
  """
  def build_ast({:vertex, dag, vertex}) do
    {_atom, [label: root_label]} = :digraph.vertex(dag, vertex)
    [node: [
        label: root_label,
        children: build_ast({:vertices, dag, :digraph.out_neighbours(dag, vertex)}) |> List.flatten 
      ]
    ]
  end

  @doc ~S"""
  Return an empty array if we've made it to the end of a branch
  """
  def build_ast({:vertices, _dag, []}), do: []

  @doc ~S"""
  Return a list containing the vertex for the current node and
  the vertices for the sibling nodes.
  """
  def build_ast({:vertices, dag, [ head | tail]}) when is_atom(head) do
    [
      build_ast({:vertex, dag, head}),
      build_ast({:vertices, dag, tail})
    ]
  end

end
