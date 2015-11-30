defmodule FDG.Importers.CypherTest do
  use ExSpec, async: true
  doctest FDG.Importers.Cypher

  @simple [
    cypher: ~S"""
      begin
        CREATE (a:Root {name: 'A'}), (b:Child {name: 'B'}), (c:Child {name: 'C'});
        MATCH (a:Root),(b:Child) CREATE (a)-[r:CHILD_OF]->(b)";
      commit
    """,
    ast: [
      {:node, [label: "A", children: [
        {:node, [label: "B", children: []]},
        {:node, [label: "C", children: []]}
      ]]}
    ]
  ]

  it "converts CYPHER into our AST" do
    assert FDG.Importers.Cypher.parse(@simple[:cypher]) == @simple[:ast]
  end
end
