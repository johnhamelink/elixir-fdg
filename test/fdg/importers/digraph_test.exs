defmodule FDG.Importers.DigraphTest do
  use ExSpec, async: true
  doctest FDG.Importers.Digraph

  @simple_ast [
    {:node, [label: "A", children: [
      {:node, [label: "B", children: []]},
      {:node, [label: "C", children: []]}
    ]]}
  ]

  it "Imports Directed Acyclic graphs (DAGs)" do
    dag = :digraph.new([:acyclic])
    :digraph.add_vertex(dag, :a, [label: "A"])
    :digraph.add_vertex(dag, :b, [label: "B"])
    :digraph.add_vertex(dag, :c, [label: "C"])
    :digraph.add_edge(dag, :a, :c)
    :digraph.add_edge(dag, :a, :b)
    assert FDG.Importers.Digraph.import(dag) == @simple_ast
  end

  it "Can be used to export with" do
    dag = :digraph.new([:acyclic])
    :digraph.add_vertex(dag, :a, [label: "A"])
    :digraph.add_vertex(dag, :b, [label: "B"])
    :digraph.add_vertex(dag, :c, [label: "C"])
    :digraph.add_edge(dag, :a, :c)
    :digraph.add_edge(dag, :a, :b)
    dot = FDG.Importers.Digraph.import(dag)
          |> FDG.Parsers.Graphviz.to_dot
    assert dot == "digraph G { a [label=\"A\"]; b [label=\"B\"]; c [label=\"C\"]; a -> b; a -> c; }"
  end

end
