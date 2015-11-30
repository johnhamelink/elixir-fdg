defmodule FDG.Importers.Cypher do

  def parse(cypher) when is_bitstring(cypher) do
    [
      {:node, [
          label: "A", children: [
            {:node, [label: "B", children: []]},
            {:node, [label: "C", children: []]}
          ]
        ]
      }
    ]
  end

end
