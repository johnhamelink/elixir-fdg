defmodule FDG.Parsers.Graphml do
  @moduledoc ~S"""
  Parses FDG AST into GraphML syntax, for exporting to
  tools like Gephi.
  """

  @doc ~S"""
  Produces a GraphML XML string from an `ast` List-of-tuples.

  ## Examples:

      iex> FDG.Parsers.Graphml.to_xml([{:node, [label: "A", children: []]}])
      "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\n\t<graph edgedefault=\"directed\" id=\"G\">\n\t\t<key attr.name=\"label\" attr.type=\"string\" for=\"node\" id=\"label\"/>\n\t\t<node id=\"a\" labels=\"A\">\n\t\t\t<data key=\"label\">A</data>\n\t\t</node>\n\t</graph>\n</graphml>"
  """
  @spec to_xml([FDG.Parser.node_tuple]) :: String.t
  def to_xml(ast) do
    [
      {:key, %{id: "label", for: "node", "attr.name": "label", "attr.type": "string"}},
      build_xml(ast)
    ] |> List.flatten
      |> List.delete(nil)
      |> xml_wrapper
      |> XmlBuilder.doc
  end

  defp build_xml([head = {:node, [label: _, children: children]}]) when is_list(children) do
    parse_graphml(head)
  end

  defp build_xml([head | tail]) do
    [
      parse_graphml(head),
      parse_graphml(tail)
    ]
  end

  @spec parse_graphml([]) :: []
  defp parse_graphml([]), do: nil

  @spec parse_graphml(FDG.Parser.node_tuple) :: [...]
  defp parse_graphml({:node, [label: label, children: children]}) when is_list(children) do
    id = FDG.Parser.normalize_label(label)
    [
      {:node, %{id: id, labels: label}, [{:data, %{key: "label"}, label}]},
      parse_graphml(children),
      parse_children_associations(id, children)
    ]
  end

  @spec parse_graphml([FDG.Parser.node_tuple]) :: [...]
  defp parse_graphml([head = {:node, [label: label, children: children]} | tail]) when is_tuple(head) and is_list(tail) do
    id = FDG.Parser.normalize_label(label)
    [
      {:node, %{id: id, labels: label}, [{:data, %{key: "label"}, label}]},
      parse_graphml(children),
      parse_graphml(tail),
      parse_children_associations(id, children)
    ] |> List.delete(nil)
  end

  @spec parse_children_associations(String.t, []) :: []
  defp parse_children_associations(_, []), do: []

  @spec parse_children_associations(String.t, [FDG.Parser.node_tuple]) :: [...]
  defp parse_children_associations(label, [child | children]) do
    [
      parse_children_associations(label, child),
      parse_children_associations(label, children)
    ] |> List.delete([])
  end

  @spec parse_children_associations(String.t, FDG.Parser.node_tuple) :: {:edge, %{}, [...]}
  defp parse_children_associations(label, {:node, [label: child_label, children: _]}) do
    parent_id = FDG.Parser.normalize_label(label)
    child_id = FDG.Parser.normalize_label(child_label)
    {:edge,
      %{
        id: "edge_#{parent_id}_#{child_id}",
        source: parent_id,
        target: child_id,
        label: "child"
      }, [{:data, %{key: "label"}, "child"}]
    }
  end

  @spec xml_wrapper([...]) :: {:graphml, %{}, [...]}
  defp xml_wrapper(content) when is_list(content) do
    {:graphml, %{
        xmlns: "http://graphml.graphdrawing.org/xmlns",
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation": "http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd"
      },
      [{:graph, %{id: "G", edgedefault: "directed"}, content }]
    }
  end

end
