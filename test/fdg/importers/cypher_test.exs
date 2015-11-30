defmodule FDG.Importers.CypherTest do
  require IEx
  use ExSpec, async: true
  doctest FDG.Importers.Cypher

  # Connect to the Neo4j Database
  @neo :neo4j.connect([{:base_uri, 'http://localhost:7474/db/data/'}])

  setup do
    # Create some nodes & Relationships
    nodes_cypher = <<"CREATE (a:Root {name: 'A'}), (b:Child {name: 'B'}), (c:Child {name: 'C'})">>
    rels_cypher = <<"MATCH (a:Root),(b:Child) CREATE (a)-[r:CHILD_OF]->(b)">>
    :neo4j.cypher(@neo, nodes_cypher)
    :neo4j.cypher(@neo, rels_cypher)

    on_exit fn ->
      # Delete the root node & all its children
      :neo4j.cypher(@neo, <<"MATCH (a:Root)-[b]-(c) DELETE a,b,c">>)
    end
  end


  it "understands nodes" do
    {graph} = :neo4j.cypher(@neo, <<"MATCH (a:Root)-[b]-(c) return a,b,c">>)
    {"columns", columns} = graph |> List.first
    {"data", data}       = graph |> List.last
    IEx.pry
  end

end
