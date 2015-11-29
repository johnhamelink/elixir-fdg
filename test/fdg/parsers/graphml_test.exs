defmodule FDG.Parsers.GraphmlTest do
  use ExSpec, async: true
  doctest FDG.Parsers.Graphml

  @simple_ast [
    {:node, [label: "A", children: [
      {:node, [label: "B", children: []]},
      {:node, [label: "C", children: []]}
    ]]}
  ]

  @multiple_nodes [
    @simple_ast,
    {:node, [label: "Root 2", children: [
      {:node, [label: "Child 1", children: []]},
      {:node, [label: "Child 2", children: []]}
    ]]}
  ]

  @simple_ast_graphml File.read!("#{__DIR__}/fixtures/simple_ast.graphml")
  @multiple_nodes_graphml File.read!("#{__DIR__}/fixtures/multiple_nodes.graphml")

  it "Creates a GraphML file from a node" do
    assert FDG.Parsers.Graphml.to_xml(@simple_ast) == @simple_ast_graphml
  end

  it "Can handle multiple root nodes" do
    assert FDG.Parsers.Graphml.to_xml(@multiple_nodes) == @multiple_nodes_graphml
  end

end
